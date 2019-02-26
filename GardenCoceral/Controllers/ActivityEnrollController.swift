//
//  ActivityEnrollController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/5/3.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class ActivityEnrollController: BaseViewController {

    var type: Int?
    var currentID: Int?
    var headImageStr : String?
    var memberModel:DynamicDetailMember!
    var showRedPacket = true
    var money = 0.0
    var back: (()->())?
    var selectedPayWay: CirclePay?
    var tableView = UITableView()
    var payWayItems = [
        CirclePay("circle-wallet", name: "余额", alias: "cash", intro: getCurrentUser().money?.string ?? "", select: true),
        CirclePay("circle-wechat", name: "微信", alias: "weixin", intro: "", select: false),
        CirclePay("circle-alipay", name: "支付宝", alias: "alipay", intro: "", select: false)
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = type == 2 ? "项目报名" : "活动报名"
        create()
    }

}
extension ActivityEnrollController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 3
        }else if section == 1 {
            return type == 1 ? 2 : 1
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as EnrollAvatarCell
            if let member = self.memberModel {
                cell.setData(model: member)
            }
            return cell
        }else if indexPath.section == 1 {
            if type == 1 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(for: indexPath) as MoodPubRpHead
                    cell.img.image = showRedPacket ? #imageLiteral(resourceName: "payway-select") : #imageLiteral(resourceName: "payway-unselect")
                    cell.name.text = "选择金额"
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(for: indexPath) as EnrollRpCell
                    cell.backRedpacket = { (money) in
                        self.money = money
                    }
                    return cell
                }
            }else {
                let cell = tableView.dequeueReusableCell(for: indexPath) as EnrollOfficialRpCell
                cell.setData(money.string)
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as CirclePayCell
            cell.setData(payWayItems[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 135
        }else {
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            if showRedPacket == true {
                showRedPacket = false
            }else {
                showRedPacket = true
            }
            tableView.reloadData()
        }else if indexPath.section == 2 {
            selectedPayWay = payWayItems[indexPath.row]
            payWayItems = payWayItems.enumerated().map{ (ip,it) in
                var item = it
                item.select = ip == indexPath.row ? true : false
                return item
            }
            tableView.reloadSections([indexPath.section], animationStyle: .fade)
        }
    }
}
extension ActivityEnrollController {
    func create() {
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = backColor
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            $0.register(cellType: EnrollAvatarCell.self)
            $0.register(nibWithCellClass: MoodPubRpHead.self)
            $0.register(cellType: EnrollRpCell.self)
            $0.register(cellType: EnrollOfficialRpCell.self)
            $0.register(cellType: CirclePayCell.self)
            $0.estimatedRowHeight = 500
            $0.delegate = self
            $0.dataSource = self
            
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 100))
            let submitBtn = UIButton(type: .custom)
            submitBtn.frame = CGRect(x: 25, y: 20, width: windowWidth-50, height: 42)
            submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            submitBtn.titleForNormal = "确 定"
            submitBtn.titleColorForNormal = .white
            submitBtn.backgroundColor = primaryBtnColor
            submitBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
            bottomView.addSubview(submitBtn)
            $0.tableFooterView = bottomView
        }
    }
    @objc func confirm() {
        applyActivity()
    }
    //报名
    func applyActivity() {
        let money = type == 1 ? showRedPacket ? self.money : 0.0 : self.money
        let payway = type == 1 ?  showRedPacket ? selectedPayWay?.alias ?? "cash" : "" : selectedPayWay?.alias ?? "cash"
        if showRedPacket {
            if money == 0 {
                SVProgressHUD.showError(withStatus: "太小气了，选个红包呗")
                return
            }
        }
        if type == 2 {
            service.attendProject("1", userToken: userToken(), id: currentID ?? 0, money: money, payType: payway).subscribe(onSuccess: { (m) in
                if m.code == 0 {
                    if payway == "weixin", let prepay = m.pay {
                        self.prepayWechat(prepay)
                    }else if payway == "alipay", let orderNo = m.orderNo {
                        self.prepayAlipay(orderNo)
                    }else { self.publishSuccess() }
                }else {
                    SVProgressHUD.showError(withStatus: m.msg ?? "请求错误")
                }
            }) { (e) in
                SVProgressHUD.showError(withStatus: "服务器异常")
                }.disposed(by: disposeBag)
        }else {
            service.attendActivity("1", userToken: userToken(), id: currentID ?? 0, money: money, payType: payway).subscribe(onSuccess: { (m) in
                if m.code == 0 {
                    if payway == "weixin", let prepay = m.pay {
                        self.prepayWechat(prepay)
                    }else if payway == "alipay", let orderNo = m.orderNo {
                        self.prepayAlipay(orderNo)
                    }else { self.publishSuccess() }
                }else {
                    SVProgressHUD.showError(withStatus: m.msg ?? "请求错误")
                }
            }) { (e) in
                SVProgressHUD.showError(withStatus: "服务器异常")
                }.disposed(by: disposeBag)
        }
    }
    func prepayAlipay(_ prepay: String) {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.alipayDelegate = self
        AlipaySDK.defaultService().payOrder(prepay, fromScheme: "gardencoceralalipay") { (dict) in
            Log(dict)
        }
    }
    func prepayWechat(_ prepay: Prepay) {
        let req = PayReq()
        req.partnerId = prepay.partnerid
        req.prepayId = prepay.prepayid
        req.nonceStr = prepay.noncestr
        req.timeStamp = UInt32(prepay.timestamp?.double() ?? 0)
        req.package = prepay.packageInfo
        req.sign = prepay.sign
        Log(req.partnerId)
        Log(req.prepayId)
        Log(req.nonceStr)
        Log(req.timeStamp)
        Log(req.package)
        Log(req.sign)
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.wxDelegate = self
        WXApi.send(req)
    }
    func publishSuccess()  {
        if let back = self.back { back() }
        SVProgressHUD.dismiss(withDelay: 1, completion: {
            self.navigationController?.popViewController()
        })
    }
}
extension ActivityEnrollController: WXDelegate, AlipayDelegate {
    func payCallback(_ response: String) {
        let res = AlipayCallback(JSONString: response)
        if res?.response?.code == "10000" {
            publishSuccess()
        }else {
            SVProgressHUD.showError(withStatus: res?.response?.msg)
        }
    }
    func paySuccessByCode(_ code: Int, returnKey: String) {
        switch code {
        case 0:
            publishSuccess()
            break
        default:
            SVProgressHUD.showError(withStatus: "支付失败")
            break
        }
        
    }
}
