//
//  RegisterController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/14.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterController: BaseViewController {

    lazy var segment = { ()->CBSegmentView2 in
        let seg = CBSegmentView2(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 50))
        seg.setTitleArray(["个人用户","企业用户"], titleFont: 15, titleColor: UIColor(hexString: "#999"), titleSelectedColor: themeColor, with: .styleSlider2)
        seg.titleChooseReturn = { (index) in
            _ = index == 0 ? (self.isPersonal = true) : (self.isPersonal = false)
            self.tableView.reloadData()
        }
        return seg
    }
    var tableView = UITableView()
    var isPersonal = true
    var personalModels = [
        TextFieldModel("请输入电话号码...", text: "", keyboardType: .numberPad),
        TextFieldModel("请输入所属机构名称...", text: "", keyboardType: .default),
        TextFieldModel("请输入职位名称...", text: "", keyboardType: .default)
    ]
    var companyModels = [
        TextFieldModel("请输入使用者手机号...", text: "", keyboardType: .numberPad),
        TextFieldModel("请输入公司简称...", text: "", keyboardType: .default),
    ]
    var imagePath: String?
    var logoPath: String?
    var licensePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "申请入会"
        create()
    }

}
extension RegisterController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isPersonal ? personalModels.count + 1 : companyModels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let arr = isPersonal ? personalModels : companyModels
        if indexPath.row == arr.count {
            if isPersonal {
                let cell = tableView.dequeueReusableCell(for: indexPath) as AddPhotoCell
                cell.backImg = { imgPath in
                    self.imagePath = imgPath
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(for: indexPath) as AddCompanyPhotosCell
                cell.backLogo = { logoPath in
                    self.logoPath = logoPath
                }
                cell.backLicense = { licensePath in
                    self.licensePath = licensePath
                }
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as OneTextFieldCell
            var model = arr[indexPath.row]
            cell.textField.text = model.text
            cell.textField.placeholder = model.placeholder
            cell.textField.keyboardType = model.keyboardType ?? .default
            cell.back = { text in
                model.text = text
                if self.isPersonal {
                    self.personalModels[indexPath.row] = model
                }else {
                    self.companyModels[indexPath.row] = model
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arr = isPersonal ? personalModels : companyModels
        return indexPath.row == arr.count ? UITableViewAutomaticDimension : 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension RegisterController {
    func create() {
        view.addSubview(segment())
        
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(50)
            })
            $0.register(cellType: OneTextFieldCell.self)
            $0.register(cellType: AddPhotoCell.self)
            $0.register(cellType: AddCompanyPhotosCell.self)
            $0.estimatedRowHeight = 200
            $0.delegate = self
            $0.dataSource = self
            
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 100))
            let submitBtn = UIButton(type: .custom)
            submitBtn.frame = CGRect(x: 60, y: 10, width: windowWidth-120, height: 50)
            submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            submitBtn.titleForNormal = "完 成"
            submitBtn.titleColorForNormal = .white
            submitBtn.backgroundColor = themeColor
            _ = submitBtn.rx.tap.bind {
                guard validateInput(self.isPersonal ? self.personalModels : self.companyModels) else {
                    return
                }
                var dict = [String]()
                if self.isPersonal {
                    dict = self.personalModels.map{$0.text ?? ""}
                    if let imgPath = self.imagePath {
                        SVProgressHUD.show()
                        self.service.uploadFile(imgPath).subscribe(onSuccess: { (m) in
                            if m.code == 0, let path = m.url {
                                self.submit(dict, path)
                            }else {
                                SVProgressHUD.showError(withStatus: m.msg ?? "图片上传出错了")
                            }
                        }).disposed(by: self.disposeBag)
                    }else {
                        SVProgressHUD.showError(withStatus: "无图无真相")
                    }
                }else {
                    dict = self.companyModels.map{$0.text ?? ""}
                    var logoUrl = ""
                    var licenseUrl = ""
                    if let logoPath = self.logoPath, let licensePath = self.licensePath {
                        SVProgressHUD.show()
                        self.service.uploadFile(logoPath).subscribe(onSuccess: { (m) in
                            if m.code == 0, let path = m.url {
                                logoUrl = path
                                if logoUrl.isEmpty == false, licenseUrl.isEmpty == false {
                                    self.submit(dict, logoUrl, licenseUrl)
                                }
                            }else {
                                SVProgressHUD.showError(withStatus: m.msg ?? "图片上传出错了")
                            }
                        }).disposed(by: self.disposeBag)
                        self.service.uploadFile(licensePath).subscribe(onSuccess: { (m) in
                            if m.code == 0, let path = m.url {
                                licenseUrl = path
                                if logoUrl.isEmpty == false, licenseUrl.isEmpty == false {
                                    self.submit(dict, logoUrl, licenseUrl)
                                }
                            }else {
                                SVProgressHUD.showError(withStatus: m.msg ?? "图片上传出错了")
                            }
                        }).disposed(by: self.disposeBag)
                    }else {
                        SVProgressHUD.showError(withStatus: "无图无真相")
                    }
                }
                Log(dict)
                
            }
            bottomView.addSubview(submitBtn)
            $0.tableFooterView = bottomView
        }
    }
    func submit(_ dict: [String], _ path: String, _ license: String = "") {
        if isPersonal {
            service.commerceApply("1", userToken: getCurrentUser().userToken ?? "", applyType: "person", name: "", companyName: dict[1], companyAddress: "", phone: dict[0], job: dict[2], logo: "", no: "", image: path, legalPerson: "")
                .subscribe(onSuccess: { (model) in
                    SVProgressHUD.dismiss()
                    if model.code == 0 {
                        SVProgressHUD.showSuccess(withStatus: "申请成功")
                        SVProgressHUD.dismiss(withDelay: 1, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }else {
                        SVProgressHUD.showError(withStatus: model.msg ?? "请求错误")
                    }
                }, onError: { error in
                    SVProgressHUD.showError(withStatus: "服务器异常")
                }).disposed(by: disposeBag)
        }else {
            service.commerceApply("1", userToken: getCurrentUser().userToken ?? "", applyType: "company", name: "", companyName: dict[1], companyAddress: "", phone: dict[0], job: "", logo: path, no: "", image: license, legalPerson: dict[1])
                .subscribe(onSuccess: { (model) in
                    SVProgressHUD.dismiss()
                    if model.code == 0 {
                        SVProgressHUD.showSuccess(withStatus: "申请成功")
                        SVProgressHUD.dismiss(withDelay: 1, completion: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }else {
                        SVProgressHUD.showError(withStatus: model.msg ?? "请求错误")
                    }
                }, onError: { error in
                    SVProgressHUD.showError(withStatus: "服务器异常")
                }).disposed(by: disposeBag)
        }
    }
}
