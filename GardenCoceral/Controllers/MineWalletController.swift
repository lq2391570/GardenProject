//
//  MineWalletController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/13.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class MineWalletController: BaseViewController {

    var tableView = UITableView()
    var response: CashRecordsResponse?
    var records = [CashRecord]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dealModel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的钱包"
        create()
    }

}
extension MineWalletController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as MineWalletCell
            if let response = self.response { cell.setData(response) }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as MemberRecordsCell
            cell.setData(records[indexPath.row-1])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension MineWalletController {
    func dealModel() {
        SVProgressHUD.show()
        service.getCashRecords("1", userToken: getCurrentUser().userToken ?? "", no: 1, size: 100).subscribe(onSuccess: { (model) in
            SVProgressHUD.dismiss()
            if model.code == 0 {
                Log(model)
                self.response = model
                if let list = model.list { self.records = list }
                self.tableView.reloadData()
            }else {
                SVProgressHUD.showError(withStatus: model.msg ?? "请求错误")
            }
        }, onError: { error in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }).disposed(by: disposeBag)
    }
    func create()  {
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            $0.register(cellType: MineWalletCell.self)
            $0.register(cellType: MemberRecordsCell.self)
            $0.estimatedRowHeight = 200
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
        }
    }
}
