//
//  MoodPubViewController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/3/28.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import SVProgressHUD
import JCAlertView

class MoodPubViewController: BaseViewController {

    var tableView = UITableView()
    var showRedPacket = false
    var imagePaths = [String]()
    var imageUrls = [String]()
    var payWayItems = [
        CirclePay("circle-wallet", name: "余额", alias: "cash", intro: getCurrentUser().money?.string ?? "", select: true),
        CirclePay("circle-wechat", name: "微信", alias: "weixin", intro: "", select: false),
        CirclePay("circle-alipay", name: "支付宝", alias: "alipay", intro: "", select: false)
    ]
    var note = ""
    var num = 0
    var money = 0.0
    var poi: AMapPOI?
    var back: (()->())?
    var selectedPayWay: CirclePay?
    var isFirstPub = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "发布心情"
        create()
        if getCurrentUser().num == 0 {
            isFirstPub = true
            showPromptView()
            refreshCurrentUser()
        }
    }
    
}
extension MoodPubViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return showRedPacket ? 3 : 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return showRedPacket ? 2 : 1
        }else {
            return showRedPacket ? payWayItems.count : 0
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as MoodPubCell
            cell.tableView = tableView
            cell.backImgs = { imgs in
                self.imagePaths = imgs
            }
            cell.backNote = { note in
                self.note = note
            }
            cell.backPoi = { poi in
                self.poi = poi
            }
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(for: indexPath) as MoodPubRpHead
                cell.img.image = showRedPacket ? #imageLiteral(resourceName: "payway-select") : #imageLiteral(resourceName: "payway-unselect")
                cell.name.text = "随个份子吧"
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(for: indexPath) as MoodPubRpView
                cell.backRedpacket = { (num,money) in
                    self.num = num
                    self.money = money
                }
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as CirclePayCell
            cell.setData(payWayItems[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            if showRedPacket == true {
                guard isFirstPub == false else { return }
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
extension MoodPubViewController {
    func create()  {
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = backColor
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            $0.register(cellType: MoodPubCell.self)
            $0.register(nibWithCellClass: MoodPubRpHead.self)
            $0.register(cellType: MoodPubRpView.self)
            $0.register(cellType: CirclePayCell.self)
            $0.estimatedRowHeight = 500
            $0.delegate = self
            $0.dataSource = self
            
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 100))
            let submitBtn = UIButton(type: .custom)
            submitBtn.frame = CGRect(x: 25, y: 20, width: windowWidth-50, height: 42)
            submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            submitBtn.titleForNormal = "发布心情"
            submitBtn.titleColorForNormal = .white
            submitBtn.backgroundColor = primaryBtnColor
            submitBtn.addTarget(self, action: #selector(publish), for: .touchUpInside)
            bottomView.addSubview(submitBtn)
            $0.tableFooterView = bottomView
        }
    }
    @objc func publish() {
        imageUrls.removeAll()
        guard !note.isEmpty else {
            SVProgressHUD.showError(withStatus: "说点什么吧")
            return
        }
        SVProgressHUD.show()
        guard imagePaths.count != 0 else {
            publishMood()
            return
        }
        for item in imagePaths {
            service.uploadFile(item).subscribe(onSuccess: { (model) in
                if model.code == 0 {
                    Log(model.url)
                    self.imageUrls.append(model.url ?? "")
                    guard self.imageUrls.count == self.imagePaths.count else {
                        return
                    }
                    self.publishMood()
                }else {
                    Log(model.msg)
                    self.imageUrls.append("上传失败")
                    SVProgressHUD.showError(withStatus: model.msg ?? "有张图片走丢了")
                }
            }).disposed(by: disposeBag)
        }
        
    }
    func publishMood() {
        let money = showRedPacket ? self.money : 0.0
        let num = showRedPacket ? self.num : 0
        let payway = showRedPacket ? selectedPayWay?.alias ?? "cash" : ""
        if showRedPacket {
            if money == 0 || num == 0 {
                SVProgressHUD.showError(withStatus: "太小气了，选个红包呗")
                return
            }
        }
        self.service.publishMood("1", userToken: getCurrentUser().userToken ?? "", note: self.note, address: self.poi?.name ?? "", lng: self.poi?.location.longitude.double ?? -122.406417, lat: self.poi?.location.latitude.double ?? 37.785834, money: money, num: num, imgs: self.imageUrls, payType: payway).subscribe(onSuccess: { (m) in
            SVProgressHUD.dismiss()
            if m.code == 0 {
                if payway == "weixin", let prepay = m.pay {
                    self.prepayWechat(prepay)
                }else if payway == "alipay", let orderNo = m.orderNo {
                    self.prepayAlipay(orderNo)
                }else { self.publishSuccess() }
            }else {
                SVProgressHUD.showError(withStatus: m.msg ?? "请求错误")
            }
        }, onError: { error in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }).disposed(by: self.disposeBag)
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
        //发布成功后发一个通知，首页刷新
        let notiName = Notification.Name(rawValue: "POSTMOODSUCCEED")
        NotificationCenter.default.post(name: notiName, object: nil, userInfo: nil)
        
        SVProgressHUD.showSuccess(withStatus: "发布成功")
        if let back = self.back { back() }
        SVProgressHUD.dismiss(withDelay: 1, completion: {
            self.navigationController?.popViewController()
        })
    }
    func showPromptView() {
        let prompt = PromptView(frame: CGRect(x: 0, y: 0, width: windowWidth - 60, height: windowWidth - 60))
        prompt.setData("初次见面，给大家发个红包吧！")
        let alert = JCAlertView(customView: prompt, dismissWhenTouchedBackground: false)
        alert?.show()
        prompt.confirmClick = {
            alert?.dismiss(completion: {
                self.showRedPacket = true
                self.tableView.reloadData()
            })
        }
    }
}
extension MoodPubViewController: WXDelegate, AlipayDelegate {
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
