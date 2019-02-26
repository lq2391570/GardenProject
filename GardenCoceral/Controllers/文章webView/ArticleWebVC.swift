//
//  ArticleWebVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/24.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
class ArticleWebVC: UIViewController,WKUIDelegate,WKNavigationDelegate {

    @IBOutlet var topView: UIView!
    
    var wkwebView:WKWebView!
    var webId = 0
    var contentSizeHeight:CGFloat = 0.0
    var isRegister = false
    var myContext:NSObject!
    
    //懒加载一个bottomView
    lazy var bottomView:WebBottomView = { () -> WebBottomView in
       let bomView = WebBottomView.newInstance()
        bomView.zanBtnClickClosure = { (btn) in
            print("点赞")
            self.giveZanForArticle()
        }
        return bomView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "头条"
        getArticleDetail()
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myContext {
            
            if self.wkwebView.isLoading == false {
                contentSizeHeight = self.wkwebView.scrollView.contentSize.height
                print("contentSizeHeight=\(contentSizeHeight)")
                self.wkwebView.frame = CGRect.init(x: 0, y: 0, width: windowWidth, height: self.wkwebView.frame.height)
                bottomView.frame = CGRect.init(x: 0, y: contentSizeHeight - 100, width: windowWidth, height: 90)
                self.bottomView.removeFromSuperview()
                self.wkwebView.sizeToFit()
                self.wkwebView.scrollView.addSubview(bottomView)
                print("self.wkwebView.frame = \(self.wkwebView.frame)")
                print("self.wkwebView.scrollView.frame = \(self.wkwebView.scrollView.frame)")
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("webView.scrollView.contentSize=\(webView.scrollView.contentSize)")
        print("didFinishcontentSizeHeight = \(contentSizeHeight)")
        self.wkwebView.scrollView.addSubview(bottomView)
        webView.evaluateJavaScript("document.body.offsetHeight") { (result, error) in
            print("webView.scrollView.contentSize2=\(webView.scrollView.contentSize)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        self.wkwebView.removeObserver(self, forKeyPath: "scrollView.contentSize", context: &myContext)
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
extension ArticleWebVC{
    //获取文章详情
    func getArticleDetail() -> Void {
        let urlStr = "https://api.shanxigl.cn/article/\(webId).htm"
        self.wkwebView = WKWebView(frame: self.topView.frame)
        self.wkwebView.uiDelegate = self
        self.wkwebView.navigationDelegate = self
        self.wkwebView.scrollView.bounces = false
        self.topView.addSubview(self.wkwebView)
        self.wkwebView.load(URLRequest.init(url: URL.init(string: urlStr)!))
        self.wkwebView.addObserver(self, forKeyPath: "scrollView.contentSize", options: NSKeyValueObservingOptions.new, context: &self.myContext)
    }
    //给文章点赞
    func giveZanForArticle() -> Void {
        startRequest(requestURLStr: zanForArticleUrl, dic: ["commerce":1,"userToken":userToken(),"id":webId], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "点赞成功")
            }else{
                SVProgressHUD.showInfo(withStatus: "未知错误")
            }
            
        }) {
            
        }
    }
}
