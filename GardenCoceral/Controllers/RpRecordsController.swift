//
//  RpRecordsController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/18.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class RpRecordsController: BaseViewController {

    lazy var segment = { ()->CBSegmentView2 in
        let seg = CBSegmentView2(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 50))
        seg.setTitleArray(["我发出的","我抢到的"], titleFont: 15, titleColor: UIColor(hexString: "#999"), titleSelectedColor: themeColor, with: .styleSlider2)
        seg.titleChooseReturn = { (index) in
            _ = index == 0 ? (self.deliver = true) : (self.deliver = false)
            self.reload()
        }
        return seg
    }
    var rpNumLabel = UILabel()
    var rpTotalLabel = UILabel()
    var rpTotal = UILabel()
    var tableView = UITableView()
    var deliver = true
    var publishedResponse: RpRecordsResponse?
    var openedResponse: RpRecordsResponse?
    var publishedRecords = [RpRecord]()
    var openedRecords = [RpRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的红包"
        create()
        dealModel()
    }
    
}
extension RpRecordsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return deliver ? publishedRecords.count : openedRecords.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = deliver ? publishedRecords : openedRecords
        if let list = arr[section].datas , arr[section].expand == true {
            return list.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(RpSectionHeader.self)
        let arr = deliver ? publishedRecords : openedRecords
        header?.setData(arr[section])
        header?.select = {
            var item = arr[section]
            item.expand = !item.expand!
            if self.deliver {
                self.publishedRecords[section] = item
            }else {
                self.openedRecords[section] = item
            }
            tableView.reloadSections([section], animationStyle: .fade)
        }
        return header
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RpRecordCell.self)
        let arr = deliver ? publishedRecords : openedRecords
        if let list = arr[indexPath.section].datas {
            cell.setData(list[indexPath.row])
        }
        return cell
    }
}
extension RpRecordsController {
    func dealModel() {
        SVProgressHUD.show()
        service.getPublishedRedPackets("1", userToken: getCurrentUser().userToken ?? "", no: 1, size: 100).subscribe(onSuccess: { (model) in
            SVProgressHUD.dismiss()
            if model.code == 0 {
                self.publishedResponse = model
                if let list = model.list {
                    self.publishedRecords = list
                }
                self.reload()
            }else {
                SVProgressHUD.showError(withStatus: model.msg)
            }
        }, onError: { error in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }).disposed(by: disposeBag)
        service.getOpenedRedPackets("1", userToken: getCurrentUser().userToken ?? "", no: 1, size: 100).subscribe(onSuccess: { (model) in
            SVProgressHUD.dismiss()
            if model.code == 0 {
                self.openedResponse = model
                if let list = model.list {
                    self.openedRecords = list
                }
                Log(model)
            }else {
                SVProgressHUD.showError(withStatus: model.msg)
            }
        }).disposed(by: disposeBag)
    }
    func create() {
        view.addSubview(segment())
        _ = rpNumLabel.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(75)
                m.left.equalTo(15)
                m.height.equalTo(21)
                m.width.lessThanOrEqualTo(windowWidth/2-15)
            })
            $0.textColor = UIColor(hex: "#333")
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.text = "已发出0个红包"
        }
        _ = rpTotal.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(rpNumLabel)
                m.right.equalTo(-15)
                m.height.equalTo(21)
                m.width.lessThanOrEqualTo(windowWidth/2-85)
            })
            $0.textColor = themeColor
            $0.font = UIFont.systemFont(ofSize: 25)
        }
        _ = rpTotalLabel.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(rpNumLabel)
                m.right.equalTo(rpTotal.snp.left).inset(5)
                m.height.equalTo(21)
                m.width.equalTo(65)
            })
            $0.textColor = UIColor(hex: "#333")
            $0.text = "总金额："
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        let line = UIView().then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(rpNumLabel.snp.bottom).offset(15)
                m.left.right.equalToSuperview()
                m.height.equalTo(1)
            })
            $0.backgroundColor = lineColor
        }
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(line.snp.bottom)
            })
            $0.register(headerFooterViewType: RpSectionHeader.self)
            $0.register(cellType: RpRecordCell.self)
            $0.estimatedRowHeight = 100
            $0.estimatedSectionHeaderHeight = 100
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.tableFooterView = UIView()
        }
    }
    func reload() {
        if deliver {
            rpNumLabel.text = "已发出\(publishedResponse?.list?.count ?? 0)个红包"
            rpTotal.text = publishedResponse?.money?.string ?? ""
        }else {
            rpNumLabel.text = "已抢得\(openedResponse?.list?.count ?? 0)个红包"
            rpTotal.text = openedResponse?.money?.string ?? ""
        }
        tableView.reloadData()
    }
}
