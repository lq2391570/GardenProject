//
//  FirstVCTitleView.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/3/29.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SVProgressHUD
class FirstVCTitleView: UIView,LMJEndlessLoopScrollViewDelegate {
    
    @IBOutlet var sdScrollView: UIView!
    
    @IBOutlet var newsScrollView: UIScrollView!
    
    @IBOutlet var smlBgView: UIView!
    
    var contentViewArray:[UIView] = []
    var AdListArray:NSMutableArray!
    var hotArticleBassClass:HotArticleHotArticleBassClass!
    var selectTopActicleClosure:((_ model:HotArticleList) -> (Void))?
    var hotNewsClickClosure:((UIButton) -> ())?
    @IBOutlet var headImageView: UIImageView!
    
    //懒加载
    lazy var newsView1:NewsView = { () -> NewsView in
        let tempView = NewsView.newInstance()
        tempView.label1.textColor = commentTextColor
        tempView.label2.textColor = commentTextColor
        return tempView
    }()
    lazy var newsView2:NewsView = { () -> NewsView in
        let tempView = NewsView.newInstance()
        tempView.label1.textColor = commentTextColor
        tempView.label2.textColor = commentTextColor
        return tempView
    }()
    lazy var newsView3:NewsView = { () -> NewsView in
        let tempView = NewsView.newInstance()
        tempView.label1.textColor = commentTextColor
        tempView.label2.textColor = commentTextColor
        return tempView
    }()
    lazy var newsView4:NewsView = { () -> NewsView in
        let tempView = NewsView.newInstance()
        tempView.label1.textColor = commentTextColor
        tempView.label2.textColor = commentTextColor
        tempView.label1.text = "第四页了"
        tempView.label2.text = "商会会长一行考察杨凌商会"
        return tempView
    }()
    lazy var newsView5:NewsView = { () -> NewsView in
        let tempView = NewsView.newInstance()
        tempView.label1.textColor = commentTextColor
        tempView.label2.textColor = commentTextColor
        tempView.label1.text = "第五页了"
        tempView.label2.text = "商会会长一行考察杨凌商会"
        return tempView
    }()
    
    @IBAction func hotNewBtnClick(_ sender: UIButton) {
        if self.hotNewsClickClosure != nil {
            self.hotNewsClickClosure!(sender)
        }
    }
    @objc func label1Click() -> Void {
        print("label1点击")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    static func newInstance() -> FirstVCTitleView{
        let view = Bundle.main.loadNibNamed("FirstVCTitleView", owner: self, options: nil)? .last as! FirstVCTitleView
      
        return view
    }
    
    //获取10条头条新闻
    func getHotArticle() -> Void {
        startRequest(requestURLStr: hotArticleUrl, dic: ["commerce":1,"userToken":userToken(),"no":1,"size":6], actionHandler: { (jsonStr) in
         print("头条 = \(jsonStr)")
            if jsonStr["code"] == 0 {
                self.hotArticleBassClass = HotArticleHotArticleBassClass(json: jsonStr)
                
                if self.hotArticleBassClass.list?.count == 1 {
                      let model1 = self.hotArticleBassClass.list![0]
                     self.newsView1.label1.text = model1.title
                     self.newsView1.label2.text = ""
                      self.contentViewArray.append(self.newsView1)
                }else if self.hotArticleBassClass.list?.count == 2 {
                    let model1 = self.hotArticleBassClass.list![0]
                     let model2 = self.hotArticleBassClass.list![1]
                     self.newsView1.label1.text = model1.title
                     self.newsView1.label2.text = model2.title
                      self.contentViewArray.append(self.newsView1)
                }else if self.hotArticleBassClass.list?.count == 3 {
                    let model1 = self.hotArticleBassClass.list![0]
                    let model2 = self.hotArticleBassClass.list![1]
                    let model3 = self.hotArticleBassClass.list![2]
                    self.newsView1.label1.text = model1.title
                    self.newsView1.label2.text = model2.title
                     self.newsView2.label1.text = model3.title
                    self.newsView2.label2.text = ""
                    self.contentViewArray.append(self.newsView1)
                    self.contentViewArray.append(self.newsView2)
                }else if self.hotArticleBassClass.list?.count == 4 {
                    let model1 = self.hotArticleBassClass.list![0]
                    let model2 = self.hotArticleBassClass.list![1]
                    let model3 = self.hotArticleBassClass.list![2]
                    let model4 = self.hotArticleBassClass.list![3]
                    self.newsView1.label1.text = model1.title
                    self.newsView1.label2.text = model2.title
                    self.newsView2.label1.text = model3.title
                     self.newsView2.label2.text = model4.title
                    self.contentViewArray.append(self.newsView1)
                    self.contentViewArray.append(self.newsView2)
                }else if self.hotArticleBassClass.list?.count == 5 {
                    let model1 = self.hotArticleBassClass.list![0]
                    let model2 = self.hotArticleBassClass.list![1]
                    let model3 = self.hotArticleBassClass.list![2]
                    let model4 = self.hotArticleBassClass.list![3]
                    let model5 = self.hotArticleBassClass.list![4]
                    self.newsView1.label1.text = model1.title
                    self.newsView1.label2.text = model2.title
                    self.newsView2.label1.text = model3.title
                    self.newsView2.label2.text = model4.title
                    self.newsView3.label1.text = model5.title
                    self.newsView3.label2.text = ""
                    self.contentViewArray.append(self.newsView1)
                    self.contentViewArray.append(self.newsView2)
                    self.contentViewArray.append(self.newsView3)
                }else if self.hotArticleBassClass.list?.count == 6 {
                    let model1 = self.hotArticleBassClass.list![0]
                    let model2 = self.hotArticleBassClass.list![1]
                    let model3 = self.hotArticleBassClass.list![2]
                    let model4 = self.hotArticleBassClass.list![3]
                    let model5 = self.hotArticleBassClass.list![4]
                    let model6 = self.hotArticleBassClass.list![5]
                    self.newsView1.label1.text = model1.title
                    self.newsView1.label2.text = model2.title
                    self.newsView2.label1.text = model3.title
                    self.newsView2.label2.text = model4.title
                    self.newsView3.label1.text = model5.title
                    self.newsView3.label2.text = model6.title
                    self.contentViewArray.append(self.newsView1)
                    self.contentViewArray.append(self.newsView2)
                    self.contentViewArray.append(self.newsView3)
                }
                
              
            }
            self.newsView1.frame = CGRect.init(x: 0, y: 0, width: self.smlBgView.frame.size.width, height: 80)
            self.newsView2.frame = CGRect.init(x: 0, y: 0, width: self.smlBgView.frame.size.width, height: 80)
            self.newsView3.frame = CGRect.init(x: 0, y: 0, width: self.smlBgView.frame.size.width, height: 80)
//            self.contentViewArray.append(self.newsView1)
//            self.contentViewArray.append(self.newsView2)
//            self.contentViewArray.append(self.newsView3)
            let newScrollView = LMJEndlessLoopScrollView(frame: CGRect.init(x: 0, y: 0, width: self.smlBgView.frame.size.width, height: self.smlBgView.frame.size.height), animationScrollDuration: 3)
            newScrollView?.delegate = self
            self.smlBgView.addSubview(newScrollView!)
            
        }) {
            
        }
    }
    //获取广告
    func getADList() -> Void {
        startRequest(requestURLStr: getADListUrl, dic: ["commerce":1,"userToken":userToken()], actionHandler: { (jsonStr) in
            let AdModel = ADListADList(json: jsonStr)
            self.AdListArray = NSMutableArray(array: AdModel.list ?? [])
            let cycleScrollView = SDCycleScrollView.init(frame: self.sdScrollView.bounds, imageNamesGroup: ["加载图片","加载图片","加载图片"])
            cycleScrollView?.pageControlDotSize = CGSize.init(width: 6, height: 6)
            var imgUrlList:[String] = []
            if self.AdListArray.count != 0 {
                for model in self.AdListArray {
                    let listModel = model as! ADListList
                    imgUrlList.append(listModel.url!)
                }
            }
            print("self.AdListArray =\(self.AdListArray)")
            cycleScrollView?.imageURLStringsGroup = imgUrlList
            cycleScrollView?.pageControlStyle = .init(1)
            self.sdScrollView.addSubview(cycleScrollView!)
            
        }) {
            
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        getHotArticle()
        self.AdListArray = NSMutableArray(capacity: 0)
        getADList()

    }
    //scrollView代理
    func numberOfContentViews(in loopScrollView: LMJEndlessLoopScrollView!) -> Int {
        return self.contentViewArray.count
    }
    func loopScrollView(_ loopScrollView: LMJEndlessLoopScrollView!, contentViewAt index: Int) -> UIView! {
        return self.contentViewArray[index]
    }
    func loopScrollView(_ loopScrollView: LMJEndlessLoopScrollView!, currentContentViewAt index: Int) {
        

    }
    func loopScrollView(_ loopScrollView: LMJEndlessLoopScrollView!, didSelectContentViewAt index: Int, topOrBottom: Int) {
        print("点击了第\(index)个，topOrBottom = \(topOrBottom)")
        let listModel:HotArticleList = self.hotArticleBassClass.list![index*2 + topOrBottom]
        if self.selectTopActicleClosure != nil {
            self.selectTopActicleClosure!(listModel)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     
    */
    @IBAction func circleClick(_ sender: UIButton) {
        judgeUserState { (state) in
            if state == 4 {
                //未登录
              //  SVProgressHUD.showInfo(withStatus: "未登录")
                let vc = LoginController()
                self.parentViewController?.navigationItem.backBarButtonItem?.tintColor = navBarColor
                self.parentViewController?.navigationController?.pushViewController(vc)
            }else{
                let vc = MyCirecleVC()
                vc.cirType = .MyCircleType
                self.parentViewController?.navigationController?.pushViewController(vc)
            }
        }
        
    }
    @IBAction func briefBtnClick(_ sender: UIButton) {
        //商会简介
        let vc = BriefWebVC()
        vc.webType = .briefType
        parentViewController?.navigationController?.pushViewController(vc)
        
    }
    @IBAction func memberElegantBtnClick(_ sender: UIButton) {
        //会员风采
        let vc = MemberElegant()
        parentViewController?.navigationController?.pushViewController(vc)
    }
    
    @IBAction func partnerBtnClick(_ sender: UIButton) {
        //合作项目
        judgeUserState { (state) in
            if state == 4 {
                //未登录
              //  SVProgressHUD.showInfo(withStatus: "未登录")
              let vc = LoginController()
                self.parentViewController?.navigationItem.backBarButtonItem?.tintColor = navBarColor
                self.parentViewController?.navigationController?.pushViewController(vc)
                
                
                
            }else{
                let vc = PartnerVC()
               self.parentViewController?.navigationController?.pushViewController(vc)
            }
        }
        
       
    }
    
    @IBAction func supportBtnClick(_ sender: UIButton) {
        
        SVProgressHUD.showInfo(withStatus: "敬请期待")
    }
    
    
}
