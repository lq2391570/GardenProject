//
//  AppDelegate.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate, AlipayDelegate {

    var window: UIWindow?
    weak var wxDelegate: WXDelegate?
    weak var alipayDelegate: AlipayDelegate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AMapServices.shared().apiKey = "df0da20ea69bc1225cc8f441327f543a"
        IQKeyboardManager.sharedManager().enable = true
        WXApi.registerApp("wx1f6e9bb23ba7d363")
        
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setBackgroundColor(themeColor!)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setCornerRadius(5)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        
        refreshCurrentUser()
        
        //获取沙河路径
        let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        print("dicDir=\(documentPath)")
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (dict) in
                guard let response = dict as? Dictionary<String, AnyObject> else {
                    return
                }
                if let result = response["result"] as? String {
                    if let delegateOK = self.alipayDelegate{
                        delegateOK.payCallback?(result)
                    }
                }
            })
            return true
        }
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func onResp(_ resp: BaseResp!) {
        //登录
        if resp.isKind(of: SendAuthResp.self) {
            if resp.errCode == 0 {
                let aresq = resp as! SendAuthResp
                if let delegateOK = self.wxDelegate{
                    delegateOK.loginSuccessByCode?(aresq.code)
                }
            }
        }
        //分享
        if resp.isKind(of: SendMessageToWXResp.self) {
            if resp.errCode == 0 {
                let aresq = resp as! SendMessageToWXResp
                if let delegateOK = self.wxDelegate{
                    delegateOK.shareSuccessByCode?(Int(aresq.errCode))
                }
            }
        }
        //支付
        if resp.isKind(of: PayResp.self) {
            let aresq = resp as! PayResp
            if let delegateOK = self.wxDelegate{
                delegateOK.paySuccessByCode?(Int(resp.errCode), returnKey: aresq.returnKey)
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
@objc protocol WXDelegate {
    @objc optional func loginSuccessByCode(_ code: String)
    @objc optional func paySuccessByCode(_ code: Int, returnKey: String)
    @objc optional func shareSuccessByCode(_ code: Int)
}
@objc protocol AlipayDelegate {
    @objc optional func payCallback(_ response: String)
}
