//
//  AddBankCardController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddBankCardController: BaseViewController {

    var tableView = UITableView()
    var itemArr = [
        TextFieldModel("银行名称...", text: "", keyboardType: .default),
        TextFieldModel("银行卡号...", text: "", keyboardType: .numberPad),
        TextFieldModel("持卡人...", text: "", keyboardType: .default),
        TextFieldModel("开户银行...", text: "", keyboardType: .default),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "添加新卡"
        create()
    }

}
extension AddBankCardController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as OneLabelCell
            cell.name.text = "请添加本人银行卡"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as OneTextFieldCell
            var model = itemArr[indexPath.row - 1]
            cell.textField.placeholder = model.placeholder
            cell.textField.keyboardType = model.keyboardType!
            cell.back = { text in
                model.text = text
                self.itemArr[indexPath.row - 1] = model
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension AddBankCardController {
    func create()  {
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            $0.register(cellType: OneLabelCell.self)
            $0.register(cellType: OneTextFieldCell.self)
            $0.rowHeight = 60
            $0.delegate = self
            $0.dataSource = self
            
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 120))
            let line = UIView(frame: CGRect(x: 15, y: 0, width: bottomView.width-15, height: 1))
            line.backgroundColor = lineColor
            bottomView.addSubview(line)
            let submitBtn = UIButton(type: .custom)
            submitBtn.frame = CGRect(x: 60, y: 60, width: windowWidth-120, height: 50)
            submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            submitBtn.titleForNormal = "完 成"
            submitBtn.titleColorForNormal = .white
            submitBtn.backgroundColor = themeColor
            submitBtn.addTarget(self, action: #selector(add), for: .touchUpInside)
            bottomView.addSubview(submitBtn)
            $0.tableFooterView = bottomView
        }
    }
    @objc func add() {
        guard validateInput(itemArr) else {
            return
        }
        SVProgressHUD.show()
        service.addBackCard("1", userToken: getCurrentUser().userToken ?? "", bankName: itemArr[0].text!, bankNo: itemArr[1].text!, name: itemArr[2].text!, initBank: itemArr[3].text!).subscribe(onSuccess: { (model) in
            SVProgressHUD.dismiss()
            if model.code == 0 {
                SVProgressHUD.showSuccess(withStatus: "添加成功")
                SVProgressHUD.dismiss(withDelay: 1, completion: {
                    self.navigationController?.popViewController()
                })
            }else {
                SVProgressHUD.showError(withStatus: model.msg ?? "添加失败")
            }
        }, onError: { error in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }).disposed(by: disposeBag)
    }
}
