//
//  FirstVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/3/26.
//  Copyright © 2018年 tongna. All rights reserved.
//
//
//1.键盘高度算出来  yes
//2.按钮距离底部的距离 yes
//3.(按钮的位置是键盘高度 + 10 )
//4.按钮在tableView上，所以tableView需要偏移
//5.tableView偏移量 = 原来的偏移量 +（按钮距离self.view底部的位置 - 键盘高度）向下
//6.键盘收起来之后偏移量恢复（记录原来的偏移量）

//                self.keyBoardView.becomeFirstResponder()
//                //获取当前点击的mesBtn坐标,相对于屏幕
//                let btnFrame = btn.convert(btn.bounds, to: self.view)
//                print("btnFrame = %@",btnFrame)
//                //按钮离底部的高度
//                self.heightOfBtnWithBottom = Double(self.view.frame.size.height - btnFrame.origin.y) - 50
//                print("self.heightOfBtnWithBottom = %f",self.heightOfBtnWithBottom)
//                //tableView需要滚动的距离（键盘的高度 - 按钮离底部的高度）
//                self.heightOfScroll = self.heightOfTextViewAndKeyBoard - self.heightOfBtnWithBottom
//                print("self.heightOfScroll = %0.f",self.heightOfScroll)
//                //记录tableView之前的偏移量
//                self.oldTableViewOffset = self.newTableViewOffset
//                self.tableView.setContentOffset(CGPoint.init(x: 0, y:CGFloat(self.newTableViewOffset.y) + CGFloat(self.heightOfScroll)), animated: true)
//                print("点击了第%d个按钮",indexPath.section)
//
import UIKit
import SDCycleScrollView
import MJRefresh
import JCAlertView
import UITableView_FDTemplateLayoutCell
import SVProgressHUD
import SwiftyJSON
import MPCoachMarks

class FirstVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var newsScrollView: UIScrollView!
    @IBOutlet var sdScrollview: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var hotBacketBtn: UIButton!
    
  
    
    var titleView:FirstVCTitleView!
    //键盘和输入框高度
    var heightOfTextViewAndKeyBoard = 393.0 // 默认一个键盘高度
    //按钮距离底部的距离
    var heightOfBtnWithBottom = 0.0
    //tableView 需要滚动的高度
    var heightOfScroll = 0.0
    //tableView 新的偏移量
    var newTableViewOffset:CGPoint!
    //tableView 原来的偏移量
    var oldTableViewOffset:CGPoint!
    //商圈动态model
    var activityAndMoodModel:ActivityActivityBassClass!
    //最大红包model
    var biggestHotBacketModel:BiggestHotBacketBiggestHotBacket!
    //红包列表model
    var hotBacketListModel:BacketListBacketListBassClass!
    //顶部刷新
    var header = MJRefreshHeader()
    //底部刷新
    var footer = MJRefreshFooter()
    //tempArray
    var tempArray:NSMutableArray!
    //当前页
    var currentPage = 2
    //输入框输入内容
    var sendText = ""
     var user: UserModel?
    lazy var keyBoardView:LZBKeyBoardToolEmojiBar = { () -> LZBKeyBoardToolEmojiBar in
        let keyboardView = LZBKeyBoardToolEmojiBar.showKeyBoard(withConfigToolBarHeight: 0, sendTextCompletion: { (str) in
            self.sendText = str!
            print("sendText = %@",self.sendText)
        })
        keyboardView?.setInputViewPlaceHolderText("请输入文字")
        return keyboardView!
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   navigationController?.isNavigationBarHidden = true
         self.navigationItem.backBarButtonItem?.tintColor = .white
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.automaticallyAdjustsScrollViewInsets = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "DynamicCell", bundle: nil), forCellReuseIdentifier: "DynamicCell")
        tableView.register(UINib.init(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.tableHeaderView = createTitleView()
        self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
            self.getActivityList()
            self.hotBacketList2()
        })
        self.tableView.mj_footer = setUpMJFooter(refreshingClosure: {
                        print("加载更多")
            self.getMoreActivityList()
        })
        self.tableView.mj_header.beginRefreshing()
        //添加带输入框的键盘
        self.view.addSubview(keyBoardView)
        self.keyBoardView.isHidden = true
        self.getActivityList()
        print("userToken=\(userToken())")
        judgeUserState { (state) in
            if state == 4 {
                //未登录
            }else{
                self.getBiggestHotbacket()
            }
        }
        //接收通知（退出登录）
        let notifi = Notification.Name.init("loginOut")
        NotificationCenter.default.addObserver(self, selector: #selector(loginOutReset), name: notifi, object: nil)
        //接受通知 (登陆)
        let loginInNotifi = Notification.Name(rawValue: "loginIn")
        NotificationCenter.default.addObserver(self, selector: #selector(loginInReset), name: loginInNotifi, object: nil)
        //接受通知 （发布心情和活动成功）
        let notiMoodName = Notification.Name(rawValue: "POSTMOODSUCCEED")
        NotificationCenter.default.addObserver(self, selector: #selector(reflashList), name: notiMoodName, object: nil)
        let notiActName = Notification.Name(rawValue: "POSTACTSUCCEED")
        NotificationCenter.default.addObserver(self, selector: #selector(reflashList), name: notiActName, object: nil)
       
    

        
        
        
    }
    //引导页
    func addGuidePage() -> Void {
        
//        var rect:CGRect!
//        if isIphone5 {
//            rect = CGRect.init(x: 200, y: 300, width: 60, height: 60)
//        }else if isIphone6 {
//
//        }else if isIphone6P {
//
//        }else if isIphoneX {
//
//        }else{
//            //4s或ipad
//        }
        
        
        let rect = titleView.headImageView.convert(titleView.headImageView.bounds, to: self.navigationController?.view)
//        let rect2 = titleView.headImageView.convert(titleView.headImageView.bounds, from: self.navigationController?.view)
        
        print("rect = \(rect)")
       // print("rect2 = \(rect2)")
        let coachmark = CGRect.init(x: rect.origin.x - 10, y: rect.origin.y - 10  , width: rect.size.width + 20, height: rect.size.height + 20)
        
        let coachMarks = [["rect":NSValue.init(cgRect: coachmark),
                           "caption":"进入个人中心后可以发布心情和活动哦",
                           "shape":NSNumber.init(value: 1),
                           "alignment":NSNumber.init(value: 2),
                           "position":NSNumber.init(value: 0),
                           "showArrow":NSNumber.init(value: false)
                           ]]
        let coachMarksView = MPCoachMarks(frame: (self.navigationController?.view.bounds)!, coachMarks: coachMarks)
       // coachMarksView?.arrowImage = UIImageView.init(image: UIImage.init(named: "引导箭头.png"))
        coachMarksView?.enableSkipButton = false
        coachMarksView?.enableContinueLabel = false
        self.navigationController?.view.addSubview(coachMarksView!)
        coachMarksView?.start()
    }
    
    @objc func reflashList() -> Void {
        self.getActivityList()
    }
    //接收退出登录通知
    @objc func loginOutReset() -> Void {
        print("退出登录")
        self.getActivityList()
       titleView.headImageView.sd_setImage(with: URL.init(string: getCurrentUser().avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: nil)
    
    }
    //登陆成功
    @objc func loginInReset() -> Void {
        print("登录成功")
        let userDefault = UserDefaults.standard
        let LoginState = userDefault.integer(forKey: "numOfLogin")
        if LoginState != 1 {
                let time: TimeInterval = 0.5
            //查看是否为第一次登陆状态，是的话弹出引导
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        //code
                        print("0.5 秒后输出")
                   
                        //添加一个引导页
                       self.addGuidePage()
                    }
             userDefault.set(1, forKey: "numOfLogin")
        }
        
        
        self.getActivityList()
        titleView.headImageView.sd_setImage(with: URL.init(string: getCurrentUser().avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: nil)
    }
    
    @IBAction func bigHotBacketClick(_ sender: UIButton) {
        //抢大红包
      hotBacketList()
       
    }
    //弹出大红包
    func popBigHotBacket(_ model:BiggestHotBacketBiggestHotBacket) -> Void {
        let bigHotbacketView = BigHotBacketView.newInstance()
        let customAlert = JCAlertView.init(customView: bigHotbacketView, dismissWhenTouchedBackground: true)
        customAlert?.show()
        bigHotbacketView.nameLabell.text = "\(model.member?.name ?? "")-\(model.member?.job ?? "")"
        bigHotbacketView.pullDownClickClosure = { (btn) in
            print("拆红包")
            self.robHotBacket(model.id!, {(jsonStr) in
                customAlert?.dismiss(completion: {
                    let vc = DynamicDetailVC()
                    vc.dynamicId = jsonStr["feedId"].intValue
                    self.navigationController?.pushViewController(vc)
                })
            }, fail: {(jsonStr) in
                customAlert?.dismiss(completion: {
                    SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                })
            })
        }
        
    }
    //弹出红包（红包列表）
    func popHotBacketList(_ model:BacketListBacketListBassClass) -> Void {
        let bigHotbacketView = BigHotBacketView.newInstance()
        let listModel:BacketListList = model.list![0]
        let customAlert = JCAlertView.init(customView: bigHotbacketView, dismissWhenTouchedBackground: true)
        customAlert?.show()
        bigHotbacketView.nameLabell.text = "\(listModel.member?.name ?? "")-\(listModel.member?.job ?? "")"
        bigHotbacketView.pullDownClickClosure = { (btn) in
            print("拆红包")
            self.robHotBacket(listModel.id!, {(jsonStr) in
                customAlert?.dismiss(completion: {
                    let vc = DynamicDetailVC()
                    vc.dynamicId = jsonStr["feedId"].intValue
                    self.navigationController?.pushViewController(vc)
                })
            }, fail: {(jsonStr) in
                customAlert?.dismiss(completion: {
                    SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                })
            })
        }
    }
    
    //创建titleView
    func createTitleView() -> UIView {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 356)
        titleView = FirstVCTitleView.newInstance()
        titleView.headImageView.sd_setImage(with: URL.init(string: getCurrentUser().avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: nil)
        titleView.selectTopActicleClosure = { (listModel) in
            let webVC = ArticleWebVC()
            webVC.webId = listModel.id ?? 0
            self.navigationController?.pushViewController(webVC)
        }
        titleView.hotNewsClickClosure = { (btn) in
            let hotNewVC = HotNewsVC()
            self.navigationController?.pushViewController(hotNewVC)
        }
        
        view.addSubview(titleView)
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return tableView.fd_heightForCell(withIdentifier: "DynamicCell", cacheBy: indexPath, configuration: { (cell) in
            let displayCell = cell as! DynamicCell
            let listModel:ActivityList = self.tempArray.object(at: indexPath.section) as! ActivityList
            let viewModel = FirstVCViewModel(listModel: listModel)
            displayCell.confingerFirstVCCell(with: viewModel)
            
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell") as! DynamicCell
        let listModel:ActivityList = self.tempArray.object(at: indexPath.section) as! ActivityList
        let viewModel = FirstVCViewModel(listModel: listModel)
        cell.confingerFirstVCCell(with: viewModel)
   
        cell.robHotBacketClickClosure = { (btn) in
            print("点击hotBacketBtn")
            //验证是否登陆\
            judgeUserState({ (state) in
                if state == 4 {
                    //未登录
                  //  SVProgressHUD.showInfo(withStatus: "请登录")
                    let vc = LoginController()
                    self.navigationItem.backBarButtonItem?.tintColor = navBarColor
                    self.navigationController?.pushViewController(vc)
                }else{
                    let listModel:ActivityList = self.tempArray.object(at: indexPath.section) as! ActivityList
                    let vc = DynamicDetailVC()
                    //自动抢红包
                    vc.autoRobHotBacket = true
                    vc.dynamicId = listModel.id ?? 0
                    vc.dynamicVCType = listModel.catalog == 0 ? .activityType:.moodType
                    vc.backClosure = { (zanSucceed,numOfZan) in
                        let listModel:ActivityList = self.tempArray.object(at: indexPath.section) as! ActivityList
                        if zanSucceed != nil {
                            listModel.liked = zanSucceed
                            listModel.likes = numOfZan
                            let cell = tableView.cellForRow(at: indexPath) as! DynamicCell
                            if listModel.liked == true {
                                //已经点过赞了
                                cell.numOfZan = listModel.likes!
                                cell.zanNumLabel.text = "\(cell.numOfZan)"
                                cell.zanImageView.image = UIImage.init(named: "点赞（已点）")
                                cell.zanImageView.image?.accessibilityIdentifier = "点赞（已点）"
                            }else{
                                cell.numOfZan = listModel.likes!
                                cell.zanNumLabel.text = "\(cell.numOfZan)"
                                cell.zanImageView.image = UIImage.init(named: "点赞（未点）")
                                cell.zanImageView.image?.accessibilityIdentifier = "点赞（未点）"
                            }
                            
                        }
                        
                    }
                    self.navigationController?.pushViewController(vc)
                }
            })
        }
        
        
            cell.messageBtnClickClosure = {(btn) in
                print("点击msgBtn")
                //验证是否登陆\
                judgeUserState({ (state) in
                if state == 4 {
                //未登录
             //   SVProgressHUD.showInfo(withStatus: "请登录")
                    let vc = LoginController()
                    self.navigationItem.backBarButtonItem?.tintColor = navBarColor
                    self.navigationController?.pushViewController(vc)
                }else{
                 let listModel:ActivityList = self.tempArray.object(at: indexPath.section) as! ActivityList
                let vc = DynamicDetailVC()
                    if listModel.haveRedPacket == 0 && listModel.catalog == 1 {
                        vc.currentType = .hotBacketType
                    }else{
                        vc.currentType = .commentType
                    }
                
                vc.dynamicId = listModel.id ?? 0
                vc.dynamicVCType = listModel.catalog == 0 ? .activityType:.moodType
                vc.backClosure = { (zanSucceed,numOfZan) in
                        let listModel:ActivityList = self.tempArray.object(at: indexPath.section) as! ActivityList
                        if zanSucceed != nil {
                            listModel.liked = zanSucceed
                             listModel.likes = numOfZan
                            let cell = tableView.cellForRow(at: indexPath) as! DynamicCell
                            if listModel.liked == true {
                                //已经点过赞了
                                cell.numOfZan = listModel.likes!
                                cell.zanNumLabel.text = "\(cell.numOfZan)"
                                cell.zanImageView.image = UIImage.init(named: "点赞（已点）")
                                cell.zanImageView.image?.accessibilityIdentifier = "点赞（已点）"
                            }else{
                                cell.numOfZan = listModel.likes!
                                cell.zanNumLabel.text = "\(cell.numOfZan)"
                                cell.zanImageView.image = UIImage.init(named: "点赞（未点）")
                                cell.zanImageView.image?.accessibilityIdentifier = "点赞（未点）"
                            }
                            
                        }
                    
                    }
                self.navigationController?.pushViewController(vc)
                }
            })
                
            }
        cell.zanBtnClickClosure = { (btn) in
            print("点击赞")
            
            judgeUserState({ (state) in
                if state == 4 {
                    //未登录
                 //   SVProgressHUD.showInfo(withStatus: "请登录")
                    let vc = LoginController()
                    self.navigationItem.backBarButtonItem?.tintColor = navBarColor
                    self.navigationController?.pushViewController(vc)
                }else{
                    self.zanAvtivity(listModel.id ?? 0, {
                        //点赞成功的操作
                        if cell.zanImageView.image?.accessibilityIdentifier == "点赞（已点）"{
                            cell.zanImageView.image? = UIImage.init(named: "点赞（未点）")!
                            cell.zanImageView.image?.accessibilityIdentifier = "点赞（未点）"
                            cell.numOfZan = cell.numOfZan - 1
                            cell.zanNumLabel.text = "\(cell.numOfZan)"
                        }else if cell.zanImageView.image?.accessibilityIdentifier == "点赞（未点）"{
                            cell.zanImageView.image? = UIImage.init(named: "点赞（已点）")!
                            cell.zanImageView.image?.accessibilityIdentifier = "点赞（已点）"
                            cell.numOfZan = cell.numOfZan + 1
                            cell.zanNumLabel.text = "\(cell.numOfZan)"
                        }
                    })
                }
            })
            
            
        }
        cell.shareClickClosure = {
            self.share(listModel)
        }
        cell.shieldBtnClickClosure = { _ in
            let alertSheet = UIAlertController.init(title: "提示", message: "您希望做以下操作", preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "屏蔽此条信息", style: .default, handler: { (action) in
                print("屏蔽")
                self.tempArray.removeObject(at: indexPath.section)
                self.tableView.deleteSections([indexPath.section], animationStyle: .automatic)
                let time: TimeInterval = 0.5
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    //code
                    print("0.5 秒后输出")
                    self.tableView.reloadData()
                  
                }
                
             
                
                
            })
            let action2 = UIAlertAction(title: "举报", style: .default, handler: { (action) in
                print("举报")
                SVProgressHUD.showSuccess(withStatus: "举报成功，我们将尽快处理")
            })
            let action3 = UIAlertAction(title: "什么也不做", style: .default, handler: { (action) in
                print("什么也不做")
            })
            alertSheet.addAction(action1)
            alertSheet.addAction(action2)
            alertSheet.addAction(action3)
            self.present(alertSheet, animated: true, completion: nil)
            
        }
        
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        judgeUserState { (state) in
            if state == 4 {
                //未登录
              //  SVProgressHUD.showInfo(withStatus: "请登录")
                let vc = LoginController()
                self.navigationItem.backBarButtonItem?.tintColor = navBarColor
                self.navigationController?.pushViewController(vc)
            }else{
                
                let listModel:ActivityList = self.tempArray.object(at: indexPath.section) as! ActivityList
                let vc = DynamicDetailVC()
                vc.dynamicId = listModel.id ?? 0
                vc.dynamicVCType = listModel.catalog == 0 ? .activityType:.moodType

                vc.backClosure = { (zanSucceed,numOfZan) in
                let listModel:ActivityList = self.tempArray.object(at: indexPath.section) as! ActivityList
                    if zanSucceed != nil {
                         listModel.liked = zanSucceed
                          listModel.likes = numOfZan

                         let cell = tableView.cellForRow(at: indexPath) as! DynamicCell
                        
                        if listModel.liked == true {
                            //已经点过赞了
                             cell.numOfZan = listModel.likes!
                            
                            cell.zanNumLabel.text = "\(cell.numOfZan)"
                            cell.zanImageView.image = UIImage.init(named: "点赞（已点）")
                            cell.zanImageView.image?.accessibilityIdentifier = "点赞（已点）"
                        }else{
                             cell.numOfZan = listModel.likes!
                           
                            cell.zanNumLabel.text = "\(cell.numOfZan)"
                            cell.zanImageView.image = UIImage.init(named: "点赞（未点）")
                            cell.zanImageView.image?.accessibilityIdentifier = "点赞（未点）"
                        }

                    }

                }
                self.navigationController?.pushViewController(vc)
            }
        }
       
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 15:10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
   
   func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.activityAndMoodModel != nil ? tempArray.count:0
    }

}
//接口
extension FirstVC {
    //获取商圈动态列表
    func getActivityList() -> Void {
        startRequest(requestURLStr: ActivityAndMoodListUrl, dic: ["commerce":1,"userToken":userToken(),"no":1,"size":10], actionHandler: { (jsonStr) in
            self.activityAndMoodModel = ActivityActivityBassClass(json: jsonStr)
            self.tempArray = NSMutableArray(array: self.activityAndMoodModel.list ?? [])
            let time: TimeInterval = 0.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                //code
                print("0.5 秒后输出")
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
            }
            self.currentPage = 2
            self.tableView.mj_footer.resetNoMoreData()
            
        }) {
            
        }
    }
    //抢红包
    func robHotBacket(_ packetId:Int,_ succeedClosure:@escaping (JSON) ->Void,fail failClosure:@escaping (JSON) -> Void) -> Void {
        startRequest(requestURLStr: pullDownHotBacketUrl, dic: ["commerce":1,"userToken":userToken(),"id":packetId], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("jsonStr = \(jsonStr)")
                SVProgressHUD.showSuccess(withStatus: "抢红包成功")
                succeedClosure(jsonStr)
            }else{
                failClosure(jsonStr)
            }
        }) {
            
        }
    }
    //每日最大红包
    func getBiggestHotbacket() -> Void {
        startRequest(requestURLStr: biggestHotBacketUrl, dic: ["commerce":1,"userToken":userToken()], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                //有最大红包
                self.biggestHotBacketModel = BiggestHotBacketBiggestHotBacket(json: jsonStr)
                self.popBigHotBacket(self.biggestHotBacketModel)
                self.showedBiggestHotBacket()
                
            }else{
                //无最大红包
            }
            
        }) {
            
        }
    }
    //获取更多商圈动态
    func getMoreActivityList() -> Void {
        startRequest(requestURLStr: ActivityAndMoodListUrl, dic: ["commerce":1,"userToken":userToken(),"no":currentPage,"size":10], actionHandler: { (jsonStr) in
            self.activityAndMoodModel = ActivityActivityBassClass(json: jsonStr)
            if self.activityAndMoodModel.list?.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.tempArray.addObjects(from: self.activityAndMoodModel.list!)
                self.currentPage = self.currentPage + 1
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }
            
        }) {
            
        }
    }
    //赞
    func zanAvtivity(_ activityId:NSInteger,_ resultClosure:@escaping () ->Void) -> Void {
        startRequest(requestURLStr: zanUrl, dic: ["commerce":1,"userToken":userToken(),"id":activityId], actionHandler: { (jsonStr) in
            print("userToken=\(userToken())")
            print("userToken2=\(getCurrentUser().userToken)")
            if jsonStr["code"] == 0 {
                print("点赞成功")
                resultClosure()
            }else{
                print("点赞失败")
            }
        }) {
            
        }
    }
    //客户端显示了最大红包
    func showedBiggestHotBacket() -> Void {
        startRequest(requestURLStr: biggestHotPacketShowedUrl, dic: ["commerce":1,"userToken":userToken()], actionHandler: { (jsonStr) in
            
            
        }) {
            
        }
    }
    //红包列表
    func hotBacketList() -> Void {
        startRequest(requestURLStr: firstVCHotBacketListUrl, dic: ["commerce":1,"userToken":userToken()], actionHandler: { (jsonStr) in
             self.hotBacketListModel = BacketListBacketListBassClass(json: jsonStr)
            print("红包列表 = \(jsonStr)")
            if self.hotBacketListModel.list?.count == 0 || self.hotBacketListModel.list == nil {
                self.hotBacketBtn.isHidden = true
                return
            }
             self.popHotBacketList(self.hotBacketListModel)
        }) {
            
        }
    }
    //红包列表2
    func hotBacketList2() -> Void {
        startRequest(requestURLStr: firstVCHotBacketListUrl, dic: ["commerce":1,"userToken":userToken()], actionHandler: { (jsonStr) in
            self.hotBacketListModel = BacketListBacketListBassClass(json: jsonStr)
            print("红包列表 = \(jsonStr)")
            if self.hotBacketListModel.list?.count == 0 || self.hotBacketListModel.list == nil {
                self.hotBacketBtn.isHidden = true
                return
            }else{
                self.hotBacketBtn.isHidden = false
            }
          
        }) {
            
        }
    }
    func share(_ model: ActivityList) {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.wxDelegate = self
        
        let wxMinObject = WXMiniProgramObject()
        wxMinObject.webpageUrl = ""
        wxMinObject.userName = "gh_ae86a1eef9c9"
        wxMinObject.path = "pages/login/login?type=1&active=\(model.catalog!)&id=\(model.id!)"
        if model.images?.count == 0 {
            wxMinObject.hdImageData = #imageLiteral(resourceName: "login-logo").compressedData()
        }else {
            do {
                let imageData = try Data(contentsOf: URL(string: model.images![0].url!)!)
                if let image = UIImage(data: imageData) {
                    wxMinObject.hdImageData = UIImageJPEGRepresentation(image, 0.1)
                }
            } catch {
                
            }
        }
        wxMinObject.miniProgramType = .test
        
        let message = WXMediaMessage()
        message.title = model.catalog == 0 ? model.activity?.note : model.note
        message.mediaObject = wxMinObject
        message.thumbData = nil
        
        let req = SendMessageToWXReq()
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        
        WXApi.send(req)
    }
    
    
    
}
extension FirstVC: WXDelegate {
    func shareSuccessByCode(_ code: Int) {
        if code == 0 {
            SVProgressHUD.showSuccess(withStatus: "分享成功")
        }
    }
}
