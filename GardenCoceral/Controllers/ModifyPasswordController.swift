//
//  ModifyPasswordController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/13.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class ModifyPasswordController: BaseViewController {

    var tableView = UITableView()
    var itemArr = [
        TextFieldModel("请输入原密码....", text: "", keyboardType: .default),
        TextFieldModel("请输入新的密码...", text: "", keyboardType: .default),
        TextFieldModel("请再次输入新密码...", text: "", keyboardType: .default)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "修改密码"
        create()
    }

}
extension ModifyPasswordController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as OneTextFieldCell
        var model = itemArr[indexPath.row]
        cell.textField.placeholder = model.placeholder
        cell.textField.keyboardType = model.keyboardType!
        cell.back = { text in
            model.text = text
            self.itemArr[indexPath.row] = model
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ModifyPasswordController {
    func create()  {
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            $0.register(cellType: OneTextFieldCell.self)
            $0.rowHeight = 60
            $0.delegate = self
            $0.dataSource = self
            
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 100))
            let submitBtn = UIButton(type: .custom)
            submitBtn.frame = CGRect(x: 60, y: 40, width: windowWidth-120, height: 50)
            submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            submitBtn.titleForNormal = "完 成"
            submitBtn.titleColorForNormal = .white
            submitBtn.backgroundColor = themeColor
            submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
            bottomView.addSubview(submitBtn)
            $0.tableFooterView = bottomView
        }
    }
    @objc func submit() {
        guard validateInput(itemArr) else {
            return
        }
        guard itemArr[1].text == itemArr[2].text else {
            SVProgressHUD.showError(withStatus: "密码不一致")
            return
        }
        SVProgressHUD.show()
        service.changePassword("1", userToken: getCurrentUser().userToken ?? "", oldPassword: itemArr[0].text ?? "", password: itemArr[1].text ?? "").subscribe(onSuccess: { (model) in
            SVProgressHUD.dismiss()
            if model.code == 0 {
                SVProgressHUD.showSuccess(withStatus: "修改成功")
                SVProgressHUD.dismiss(withDelay: 1, completion: {
                    self.navigationController?.popViewController()
                })
            }else {
                SVProgressHUD.showError(withStatus: model.msg ?? "请求错误")
            }
        }, onError: { error in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }).disposed(by: disposeBag)
    }
}
