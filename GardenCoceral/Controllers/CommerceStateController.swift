//
//  CommerceStateController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/5/28.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommerceStateController: BaseViewController {

    var tableView = UITableView()
    var model: CommerceState?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "已入会"
        create()
        dealData()
    }
}
extension CommerceStateController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as OneLabelCell
        if indexPath.row == 0 {
            cell.name.text = "入会状态：\(model?.state ?? "获取中...")"
        }else if indexPath.row == 1 {
            cell.name.text = "认证时间：\(model?.beginDate ?? "获取中...")"
        }else if indexPath.row == 2 {
            cell.name.text = "到期时间：\(model?.endDate ?? "获取中...")"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
extension CommerceStateController {
    func dealData() {
        SVProgressHUD.show()
        service.getUserCommerceState("1", userToken: userToken()).subscribe(onSuccess: { (model) in
            SVProgressHUD.dismiss()
            self.model = model
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }.disposed(by: disposeBag)
    }
    func create() {
        tableView = UITableView(frame: .zero, style: .plain).then {
            $0.backgroundColor = backColor
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            $0.register(cellType: OneLabelCell.self)
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
        }
    }
}
