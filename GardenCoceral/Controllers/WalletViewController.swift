//
//  WalletViewController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class WalletViewController: BaseViewController {

    var tableView = UITableView()
    var itemArr = [BankCard]()
    var cashResponse: CashRecordsResponse?
    var money: Double?
    var bankId: Int?
    
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
extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : itemArr.count + 2
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as WithdrawCell
            if let response = self.cashResponse { cell.setData(response) }
            cell.back = { m in
                self.money = m
            }
            return cell
        }else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(for: indexPath) as FullLabelCell
                cell.name.text = "选择银行卡"
                return cell
            }else if indexPath.row == itemArr.count + 1 {
                let cell = tableView.dequeueReusableCell(for: indexPath) as LeftMaginCell
                cell.name.text = "使用新卡提现"
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(for: indexPath) as BankCardCell
                cell.tag = indexPath.row + 100
                cell.setData(itemArr[indexPath.row - 1])
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {}
            else if indexPath.row == itemArr.count + 1 {}
            else {
                let cell = tableView.cellForRow(at: indexPath) as! BankCardCell
                cell.radio.image = #imageLiteral(resourceName: "payway-unselect")
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {}
            else if indexPath.row == itemArr.count + 1 {
                let vc = AddBankCardController()
                navigationController?.pushViewController(vc, animated: true)
            }else {
                let cell = tableView.cellForRow(at: indexPath) as! BankCardCell
                cell.radio.image = #imageLiteral(resourceName: "payway-select")
                Log(cell.tag)
                self.bankId = itemArr[indexPath.row - 1].id
            }
        }
    }
    
}
extension WalletViewController {
    func dealModel() {
        SVProgressHUD.show()
        service.getUserBankCards("1", userToken: getCurrentUser().userToken ?? "", no: 1, size: 100).subscribe(onSuccess: { (model) in
            SVProgressHUD.dismiss()
            if model.code == 0 {
                if let list = model.list { self.itemArr = list }
                self.tableView.reloadData()
            }else {
                SVProgressHUD.showError(withStatus: model.msg)
            }
        }, onError: { error in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }).disposed(by: disposeBag)
    }
    func create() {
        
        tableView = UITableView(frame: .zero, style: .plain).then {
            $0.backgroundColor = backColor
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            
            $0.register(cellType: WithdrawCell.self)
            $0.register(cellType: FullLabelCell.self)
            $0.register(cellType: BankCardCell.self)
            $0.register(cellType: LeftMaginCell.self)
            $0.delegate = self
            $0.dataSource = self
            //ios11可以不用设置estimatedRowHeight？
            $0.estimatedRowHeight = 500
            
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 100))
            let submitBtn = UIButton(type: .custom)
            submitBtn.frame = CGRect(x: 60, y: 40, width: windowWidth-120, height: 50)
            submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            submitBtn.titleForNormal = "确定"
            submitBtn.titleColorForNormal = .white
            submitBtn.backgroundColor = themeColor
            submitBtn.addTarget(self, action: #selector(withdraw), for: .touchUpInside)
            bottomView.addSubview(submitBtn)
            $0.tableFooterView = bottomView
        }
    }
    @objc func withdraw() {
        if let money = self.money, let bankId = self.bankId {
            guard money > 0.0, money <= cashResponse?.money ?? 0 else {
                SVProgressHUD.showError(withStatus: "请合理选择")
                return
            }
            SVProgressHUD.show()
            service.withdraw("1", userToken: userToken(), bankId: bankId, money: money).subscribe(onSuccess: { (m) in
                if m.code == 0 {
                    SVProgressHUD.showSuccess(withStatus: "成功")
                    SVProgressHUD.dismiss(withDelay: 1, completion: {
                        self.navigationController?.popViewController()
                    })
                }else {
                    SVProgressHUD.showError(withStatus: m.msg ?? "请求错误")
                }
            }, onError: { (e) in
                SVProgressHUD.showError(withStatus: "服务器异常")
            }).disposed(by: disposeBag)
        }else {
            SVProgressHUD.showError(withStatus: "请合理选择")
        }
    }
}
