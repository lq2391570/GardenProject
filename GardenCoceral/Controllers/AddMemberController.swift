//
//  AddMemberController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddMemberController: BaseViewController {

    var tableView = UITableView()
    var itemArr = [
        TextFieldModel("请输入姓名...", text: "", keyboardType: .default),
        TextFieldModel("请输入身份证号...", text: "", keyboardType: .numberPad),
        TextFieldModel("请输入电话号码...", text: "", keyboardType: .default),
        TextFieldModel("请输入职位名称...", text: "", keyboardType: .default)
        ]
    var imagePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加会员"
        create()
    }

}
extension AddMemberController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == itemArr.count  {
            let cell = tableView.dequeueReusableCell(for: indexPath) as AddMemberCell
            cell.backImg = { imgPath in
                self.imagePath = imgPath
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as OneTextFieldCell
            var model = itemArr[indexPath.row]
            cell.textField.text = model.text
            cell.textField.placeholder = model.placeholder
            cell.textField.keyboardType = model.keyboardType ?? .default
            cell.back = { text in
                model.text = text
                self.itemArr[indexPath.row] = model
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == itemArr.count  {
            return UITableViewAutomaticDimension
        }else {
            return 60
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension AddMemberController {
    func create()  {
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            $0.register(cellType: AddMemberCell.self)
            $0.register(cellType: OneTextFieldCell.self)
            $0.estimatedRowHeight = 500
            $0.delegate = self
            $0.dataSource = self
            
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 100))
            let submitBtn = UIButton(type: .custom)
            submitBtn.frame = CGRect(x: 60, y: 40, width: windowWidth-120, height: 50)
            submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            submitBtn.titleForNormal = "完 成"
            submitBtn.titleColorForNormal = .white
            submitBtn.backgroundColor = themeColor
            submitBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
            bottomView.addSubview(submitBtn)
            $0.tableFooterView = bottomView
        }
        let rightBtn = UIBarButtonItem(title: "添加记录", style: .plain, target: self, action: #selector(memberRecords))
        navigationItem.rightBarButtonItem = rightBtn
    }
    @objc func confirm() {
        guard validateInput(itemArr) else {
            return
        }
        if let imgPath = self.imagePath {
            SVProgressHUD.show()
            service.uploadFile(imgPath).subscribe(onSuccess: { (m) in
                if m.code == 0, let path = m.url {
                    self.addMember(path)
                }else {
                    SVProgressHUD.showError(withStatus: m.msg ?? "图片上传出错了")
                }
            }).disposed(by: disposeBag)
        }else {
            SVProgressHUD.showError(withStatus: "无图无真相")
        }
        
    }
    func addMember(_ imgPath: String) {
        service.addCommerceMemberApply("1", userToken: userToken(), applyType: "company", name: itemArr[0].text ?? "", companyName: "", companyAddress: "", phone: itemArr[2].text ?? "", job: itemArr[3].text ?? "", no: itemArr[1].text ?? "", image: imgPath, legalPerson: "").subscribe(onSuccess: { (m) in
            if m.code == 0 {
                SVProgressHUD.showSuccess(withStatus: "添加成功")
                SVProgressHUD.dismiss(withDelay: 1, completion: {
                    self.navigationController?.popViewController()
                })
            }else {
                SVProgressHUD.showError(withStatus: m.msg ?? "添加失败")
            }
        }) { (e) in
            SVProgressHUD.showError(withStatus: "服务器异常")
            }.disposed(by: disposeBag)
    }
    @objc func memberRecords() {
        let vc = MemberRecordsController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
