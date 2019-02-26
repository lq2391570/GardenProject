//
//  BriefWebVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/2.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
class BriefWebVC: BaseViewController {

    enum webType {
        case briefType //简介
        case elegantType //风采
    }
    
    @IBOutlet var contentView: UIView!
    var wkwebView:WKWebView!
    var webUrl = ""
    var webType:webType = .briefType
    var vipId = 1
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
     //    self.wkwebView.frame = self.view.frame
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.wkwebView = WKWebView(frame: self.view.bounds)
        self.contentView.addSubview(self.wkwebView)
        if self.webType == .briefType {
            //简介
            self.title = "商会简介"
            webUrl = "https://api.shanxigl.cn/commerce/1.htm"
            self.wkwebView.load(URLRequest.init(url: URL.init(string: webUrl)!))
        }else{
            self.title = "会员风采"
            webUrl = "https://api.shanxigl.cn/vipstyle/\(vipId).htm"
            self.wkwebView.load(URLRequest.init(url: URL.init(string: webUrl)!))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
