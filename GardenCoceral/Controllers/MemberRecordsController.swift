//
//  MemberRecordsController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class MemberRecordsController: BaseViewController {

    var tableView = UITableView()
    var records = [MemberRecord]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "添加记录"
        create()
        dealData()
    }

}
extension MemberRecordsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as MemberRecordsCell
        cell.setData2(records[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension MemberRecordsController {
    func dealData() {
        
        service.commerceApplyRecord("1", userToken: userToken(), no: 1, size: 100).subscribe(onSuccess: { (m) in
            if m.code == 0 {
                if let list = m.list {
                    self.records = list
                    self.tableView.reloadData()
                }
            }else {
                SVProgressHUD.showError(withStatus: m.msg ?? "请求错误")
            }
        }) { (e) in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }.disposed(by: disposeBag)
    }
    func create()  {
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            $0.register(cellType: MemberRecordsCell.self)
            $0.estimatedRowHeight = 100
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
        }
    }
}
