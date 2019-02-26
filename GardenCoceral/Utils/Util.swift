//
//  Util.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/3/27.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift

import MJRefresh

import RxCocoa
import RxSwift
import SVProgressHUD

let disposeBag = DisposeBag()
/************************  屏幕尺寸  ***************************/
// 屏幕宽度
let windowWidth = UIScreen.main.bounds.size.width

// 屏幕高度
let windowHeight = UIScreen.main.bounds.size.height

// iPhone4
let isIphone4 = windowHeight  < 568 ? true : false

// iPhone 5
let isIphone5 = windowHeight  == 568 ? true : false

// iPhone 6
let isIphone6 = windowHeight  == 667 ? true : false

// iphone 6P
let isIphone6P = windowHeight == 736 ? true : false

// iphone X
let isIphoneX = windowHeight == 812 ? true : false

// navigationBarHeight
let navigationBarHeight : CGFloat = isIphoneX ? 88 : 64

// tabBarHeight
let tabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49

func w(_ w: CGFloat) -> CGFloat {
    return w*(windowWidth/375)
}
func h(_ h: CGFloat) -> CGFloat {
    return windowHeight  >= 667 ? h : h*(windowHeight/812)
}



let themeColor = UIColor(hexString: "#f4574a")
//未入会颜色
let noVipColor = UIColor(hexString: "#2d9aff")
let backColor = UIColor(hexString: "#f3f3f3")
let lineColor = UIColor(hexString: "#ededed")
let primaryBtnColor = UIColor(hexString: "#f14345")

let commentTextColor = UIColor(hexString: "#666666")

let navBarColor = UIColor(hexString: "#B21E23")

//下拉刷新及上拉更多
func setUpMJHeader(refreshingClosure:(() ->())?) -> MJRefreshGifHeader {
    let header = MJRefreshGifHeader {
        refreshingClosure!()
    }
    header?.lastUpdatedTimeLabel.isHidden = true
    header?.stateLabel.isHidden = true
    var gifImageArray:[UIImage] = []
    for index in 0...29 {
        let str = "roll\(index).png"
        gifImageArray.append(UIImage.init(named: str)!)
    }
    header?.setImages(gifImageArray, duration: 0.5, for: .refreshing)
    return header!
}
func setUpMJFooter(refreshingClosure:(() ->())?) -> MJRefreshAutoNormalFooter {
    let footer = MJRefreshAutoNormalFooter {
        refreshingClosure!()
    }
    
    return footer!
}


enum Result {
    case ok(message: String)
    case empty
    case failed(message: String)
}

extension Result {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
extension Result {
    var textColor: UIColor {
        switch self {
        case .ok:
            return UIColor.clear
        case .empty:
            return UIColor.clear
        case .failed:
            return UIColor.red
        }
    }
}
extension Result {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .failed(message):
            return message
        }
    }
}
extension Reactive where Base: UILabel {
    var validationResult: Binder<Result> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}
extension Reactive where Base: UITextField {
    var inputEnabled: Binder<Result> {
        return Binder(base) { textFiled, result in
            textFiled.isEnabled = result.isValid
        }
    }
    var validationResult: Binder<Result> {
        return Binder(base) { textFiled, result in
            textFiled.layer.borderColor = result.textColor.cgColor
            textFiled.layer.borderWidth = CGFloat(result.isValid.int)
        }
    }
}
extension UIButton {
    func timeDown(time: Int) -> Void {
        var timeout = time//倒计时时间
        let _timer = DispatchSource.makeTimerSource(queue: .main)
        _timer.schedule(deadline: .now(), repeating: 1)//每秒执行
        _timer.setEventHandler {
            if timeout <= 0 {//倒计时结束，关闭
                _timer.cancel()
                DispatchQueue.main.async {
                    //设置界面的按钮显示 根据自己需求设置
                    self.setTitle("重新获取", for: .normal)
                    self.isUserInteractionEnabled = true
                }
            }else
            {
                let seconds = timeout % 60
                DispatchQueue.main.async {
                    //设置界面的按钮显示 根据自己需求设置
                    self.setTitle("\(seconds.string)s", for: .normal)
                    self.isUserInteractionEnabled = false
                }
                timeout -= 1
            }
        }
        _timer.resume();
    }
}
extension String {
    func isTelNumber() -> Bool
    {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9]|7[0-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluate(with: self) == true)
            || (regextestcm.evaluate(with: self)  == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true))
        {
            return true
        }
        else
        {
            return false
        }
    }
}

func setCurrentUser(_ model: UserModel) {
    let userdefault = UserDefaults.standard
    let modelJson = model.toJSONString()
    userdefault.set(modelJson, forKey: "currentUser")
    userdefault.synchronize()
}
func resetCurrentUser() {
    let userdefault = UserDefaults.standard
    userdefault.removeObject(forKey: "currentUser")
    userdefault.synchronize()
}
func getCurrentUser() -> UserModel {
    let userdefault = UserDefaults.standard
    if let modelJson = userdefault.string(forKey: "currentUser") {
        print("modelJson=\(modelJson)")
        print("UserModel = \(UserModel(JSONString: modelJson)!)")
        return UserModel(JSONString: modelJson)!
    }else{
        return UserModel(JSONString: "{\"code\":-1}")!
    }
}


func refreshCurrentUser() {
    guard let token = getCurrentUser().userToken else {
        return
    }
    MyService.shareInstance.getUserInfo("1", userToken: token).subscribe(onSuccess: { (m) in
        if m.code == 0 {
            setCurrentUser(m)
        }
    }) { (e) in
        
    }.disposed(by: disposeBag)
}
enum LoginStatus {
    case noLogin
    case loginButNoMember
    case member
}
func isMember() -> LoginStatus {
    guard let catalog = getCurrentUser().catalog else {
        return .noLogin
    }
    if catalog == 0 {
        return .member
    }else {
        return .loginButNoMember
    }
}
func validateInput(_ itemArr: [TextFieldModel]) -> Bool{
    for item in itemArr {
        if item.text!.isEmpty {
            SVProgressHUD.showError(withStatus: item.placeholder)
            return false
        }
    }
    return true
}
//判断抢最大红包时间（间隔一天）
func comparisonTime() -> Void {
    let userDefault = UserDefaults.standard
    let now = Date()
    let agoDate = userDefault.object(forKey: "nowDate")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let agoDateString = dateFormatter.string(from: agoDate as! Date)
    let nowDateString = dateFormatter.string(from: now)
    if agoDateString == nowDateString {
        //一天之内
    }else{
        //不是一天之内
    }
}
//判断是否是登陆状态
func judgeUserState(_ closure:@escaping (Int) ->Void) -> Void  {
    let catalog = getCurrentUser().catalog ?? 4
    closure(catalog)
    switch catalog {
    case 0:
        //正常
        break
    case 1:
        //没有提交
        break
    case 2:
        //提交了入会申请没交钱
        break
    case 3:
        //已过期
        break
    case 4:
        //未登录
        break
    default:
        break
    }
    
}



public class UserClass:NSObject {
 @objc public var address : String = ""
    
 @objc public func isMember() -> Bool {
        guard let catalog = getCurrentUser().catalog else {
            return false
        }
        if catalog == 0 {
            return true
        }else {
            return false
        }
    }
}


