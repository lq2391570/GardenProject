//
//  LoginController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/13.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import ETNavBarTransparent
import SVProgressHUD

class LoginController: BaseViewController {

    var logo = UIImageView()
    var phoneIcon = UIImageView()
    var phoneInput = UITextField()
    var phoneLine = UIView()
    var pwdIcon = UIImageView()
    var pwdInput = UITextField()
    var pwdLine = UIView()
    var loginBtn = UIButton()
    var forgetPwdBtn = UIButton()
    var splitLine = UIView()
    var registerBtn = UIButton()
    var thirdpartyLabel = UILabel()
    var thirdpartyIcon = UIImageView()
    var back: (()->())?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        navBarBgAlpha = 0
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.title = "登录"
     //   navBarBgAlpha = 0
        
        create()
        dealModel()
    }

}
extension LoginController {
    func dealModel() {
        let viewModel = LoginViewModel(input: (phone: phoneInput.rx.text.orEmpty.asDriver(), password: pwdInput.rx.text.orEmpty.asDriver(), loginTap: loginBtn.rx.tap.asDriver()))
        viewModel.loginButtonEnabled
            .drive(onNext: { [unowned self] valid in
                self.loginBtn.isEnabled = valid
                self.loginBtn.alpha = valid ? 1.0 : 0.5
            }).disposed(by: disposeBag)
        viewModel.loginResult.drive(
            onNext:{ r in
                guard r.isValid else {
                    SVProgressHUD.showError(withStatus: r.description)
                    return
                }
                let notifi = Notification.Name.init("loginIn")
                NotificationCenter.default.post(name: notifi, object: nil, userInfo: nil)
                SVProgressHUD.showSuccess(withStatus: r.description)
                _ = self.navigationController?.popViewController(animated: true)
                if let back = self.back {
                    back()
                }
        }).disposed(by: disposeBag)
    }
    func create() {
        _ = logo.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(h(navigationBarHeight))
                m.width.height.equalTo(120)
                m.centerX.equalToSuperview()
            })
            $0.image = #imageLiteral(resourceName: "login-logo")
        }
        _ = phoneIcon.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(logo.snp.bottom).offset(h(60))
                m.left.equalTo(40)
                m.height.equalTo(25)
                m.width.equalTo(21)
            })
            $0.image = #imageLiteral(resourceName: "login-account")
        }
        _ = phoneInput.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(phoneIcon)
                m.height.equalTo(phoneIcon)
                m.right.equalTo(-40)
                m.left.equalTo(phoneIcon.snp.right).offset(15)
            })
            $0.placeholder = "请输入手机号..."
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.clearButtonMode = .whileEditing
        }
        _ = phoneLine.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(phoneIcon)
                m.top.equalTo(phoneIcon.snp.bottom).offset(h(15))
                m.height.equalTo(1)
                m.right.equalTo(phoneInput)
            })
            $0.backgroundColor = lineColor
        }
        _ = pwdIcon.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(phoneLine.snp.bottom).offset(h(30))
                m.left.equalTo(40)
                m.height.equalTo(25)
                m.width.equalTo(21)
            })
            $0.image = #imageLiteral(resourceName: "login-password")
        }
        _ = pwdInput.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(pwdIcon)
                m.height.equalTo(pwdIcon)
                m.right.equalTo(-40)
                m.left.equalTo(pwdIcon.snp.right).offset(15)
            })
            $0.placeholder = "请输入密码..."
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.clearButtonMode = .whileEditing
            $0.isSecureTextEntry = true
        }
        _ = pwdLine.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(pwdIcon)
                m.top.equalTo(pwdIcon.snp.bottom).offset(h(15))
                m.height.equalTo(1)
                m.right.equalTo(pwdInput)
            })
            $0.backgroundColor = lineColor
        }
        _ = loginBtn.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(pwdLine.snp.bottom).offset(h(40))
                m.left.right.equalTo(pwdLine)
                m.height.equalTo(h(50))
            })
            $0.backgroundColor = themeColor
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(200))
            $0.titleForNormal = "登录"
            $0.titleColorForNormal = .white
        }
        _ = splitLine.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerX.equalToSuperview()
                m.top.equalTo(loginBtn.snp.bottom).offset(h(30))
                m.height.equalTo(22)
                m.width.equalTo(1)
            })
            $0.backgroundColor = lineColor
        }
        _ = forgetPwdBtn.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(loginBtn).offset(5)
                m.right.equalTo(splitLine.snp.left).inset(5)
                m.top.height.equalTo(splitLine)
            })
            $0.titleColorForNormal = UIColor(hex: "#999")
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.titleForNormal = "忘记密码?"
            $0.addTarget(self, action: #selector(findPasswordClick), for: .touchUpInside)
        }
        _ = registerBtn.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.right.equalTo(loginBtn).inset(5)
                m.left.equalTo(splitLine.snp.right).offset(5)
                m.top.height.equalTo(splitLine)
            })
            $0.titleColorForNormal = themeColor
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.titleForNormal = "去注册"
            $0.addTarget(self, action: #selector(registerClick), for: .touchUpInside)
        }
        _ = thirdpartyLabel.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.equalTo(loginBtn)
                if windowHeight >= 667 {
                    m.bottom.equalTo(-100)
                }else {
                    m.top.equalTo(splitLine.snp.bottom).offset(h(30))
                }
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(hex: "#999")
            $0.text = "其他登录方式"
            $0.textAlignment = .center
        }
        _  = thirdpartyIcon.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerX.equalToSuperview()
                m.top.equalTo(thirdpartyLabel.snp.bottom).offset(10)
                m.width.height.equalTo(h(50))
            })
            $0.image = #imageLiteral(resourceName: "login-wechat")
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer()
            tap.addTarget(self, action: #selector(thirdpartyLogin))
            $0.addGestureRecognizer(tap)
        }
    }
    @objc func registerClick() {
        let vc = RegisterController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func findPasswordClick() {
        let vc = FindPasswordController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func thirdpartyLogin() {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "123"
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.wxDelegate = self
        WXApi.sendAuthReq(req, viewController: self, delegate: appdelegate)
    }
    func loginOAuth(_ code: String) {
        SVProgressHUD.show()
        service.loginOAuth("1", code: code, type: "weixin").subscribe(onSuccess: { (model) in
            SVProgressHUD.dismiss()
            if model.code == 0 {
                setCurrentUser(model)
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                //登陆成功通知
               // let notifi = Notification.Name(rawValue: "loginIn")
                let notifi = Notification.Name.init("loginIn")
                NotificationCenter.default.post(name: notifi, object: nil, userInfo: nil)
                SVProgressHUD.dismiss(withDelay: 1, completion: {
                    _ = self.navigationController?.popViewController(animated: true)
                    if let back = self.back {
                        back()
                    }
                })
            }else {
                SVProgressHUD.showError(withStatus: model.msg ?? "登录失败")
            }
        }, onError: { error in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }).disposed(by: disposeBag)
    }
}
extension LoginController: WXDelegate {
    func loginSuccessByCode(_ code: String) {
        loginOAuth(code)
    }
}
