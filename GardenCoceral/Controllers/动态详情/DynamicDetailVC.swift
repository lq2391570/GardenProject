//
//  DynamicDetailVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/11.
//  Copyright © 2018年 tongna. All rights reserved.
//
//抢红包底部btn显示 1.红包抢完（灰）2.没有红包（灰）3.抢过了（灰）
//cell显示 1.红包抢完且自己没抢 2.红包没抢完且自己没抢 3.自己抢了（红包是否抢完无关）

import UIKit
import Spring
import JCAlertView
import SVProgressHUD
class DynamicDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    enum currentSelectType:Int {
        case hotBacketType = 0
        case commentType
        case zanType
        
    }
    //活动还是心情
   public enum activityOrMoodType {
        case moodType   // 心情
        case activityType  // 活动
        case moodTypeWithOutHotBacket //心情没有红包
    
    }
    var dynamicVCType:activityOrMoodType = .moodType
    @IBOutlet var tableView: UITableView!
    var dynamicId = 0
    var dynamicDetailModel:DynamicDetailDynamicDetailBassClass!
    var likeListModel:LikesLikesBassClass!
    var commentListModel:CommentListCommentListBaseClass!
    var applyListModel:DynamicApplyListDynamicApplyList!
    //已抢到的红包列表
    var alreadyHotBacketModel:HotBacketListHotBacketListBassClass!
    var currentType:currentSelectType = .hotBacketType
   
    @IBOutlet var zanImageView: SpringImageView!
    @IBOutlet var zanLabel: UILabel!
    
    @IBOutlet var zanLabel2: UILabel!
    @IBOutlet var zanImageView2: SpringImageView!
    
    
    @IBOutlet var robhotbacketAndAttentActivityBtn: UIButton!
    
    var hotBacketTempArray:NSMutableArray!
    var commentTempArray:NSMutableArray!
    var zanTempArray:NSMutableArray!
    var applyTempArray:NSMutableArray!
    var alreadyHotBacketTempArray:NSMutableArray!
    
    var commentStr = ""
    var segementView:CBSegmentView!
    //已抢红包数
    var numOfHotBacket = 0
    //总红包数
    var numOfAllHotBacket = 0
    //评论数
    var numOfComment = 0
    //点赞数
    var numOfZan = 0
    //报名数
    var numOfApply = 0
    //红包是否抢完
    var hotbacketAlreadyFinish = false
    //自己是否已经抢了红包
    var userIsRob = false
    //是否有红包
    var isHaveHotbacket = false
    //是否可以抢红包
    var isCanRobHotbacket = true
    
    //点击抢红包进入
    var autoRobHotBacket = false
    
    
    @IBOutlet var bottomView1: UIView!
    
    @IBOutlet var bottomView2: UIView!
    
    //backClosure
    var backClosure:((Bool?,Int) -> ())?
    //是否成功点赞（成功点赞返回时刷新列表）
    var zanSucceed:Bool?
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.navigationController?.viewControllers.contains(self) == false {
            print("点击了返回")
            if self.backClosure != nil {
                self.backClosure!(zanSucceed,numOfZan)
            }
        }
    }
    
    //懒加载输入框键盘
    lazy var keyBoardView:LZBKeyBoardToolBar = { () -> LZBKeyBoardToolBar in
        let keyboardView = LZBKeyBoardToolBar.showKeyBoard(withConfigToolBarHeight: 0, sendTextCompletion: { (str) in
            if str == "" {
                 SVProgressHUD.showInfo(withStatus: "请输入内容")
            }else{
                self.commentStr = str!
                self.publishComment()
                print("self.commentStr = \(self.commentStr)")
            }
            
        })
        keyboardView?.setInputViewPlaceHolderText("请输入文字")
        return keyboardView!
    }()
    //懒加载一个headerView
    lazy var headerView:UIView = { () -> UIView in
        let headerVer = UIView(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 50))
        headerVer.backgroundColor = UIColor.white
        segementView = CBSegmentView(frame: headerVer.bounds)
        if self.currentType == .commentType  {
            segementView.currentSeleCtIndex = 1
            // self.keyBoardView.becomeFirstResponder()
        }
        segementView.titleChooseReturn = { (index) in
            print("点击了第\(index)个")
            if self.dynamicVCType == .moodType && self.dynamicDetailModel.haveRedPacket == false {
                switch index {
                case 0:
                     self.currentType = .commentType
                case 1:
                    self.currentType = .zanType
                default:
                     self.currentType = .commentType
                }
            }else{
                switch index {
                case 0:
                    self.currentType = .hotBacketType
                case 1:
                    self.currentType = .commentType
                case 2:
                    self.currentType = .zanType
                default:
                    self.currentType = .hotBacketType
                }
            }
            self.tableView.reloadData()
        }
        headerVer.addSubview(segementView)
        
        print("headerVer.supViews.count = \(headerVer.subviews.count)")
        
        return headerVer
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "动态详情"
        self.bottomView2.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib.init(nibName: "DynamicCell", bundle: nil), forCellReuseIdentifier: "DynamicCellDetail")
        tableView.register(UINib.init(nibName: "DynamicCommentCell", bundle: nil), forCellReuseIdentifier: "DynamicCommentCell")
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.register(UINib.init(nibName: "ChoseHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ChoseHeaderView")
        tableView.register(UINib.init(nibName: "HotBacketHintCell", bundle: nil), forCellReuseIdentifier: "HotBacketHintCell")
        tableView.register(UINib.init(nibName: "HotBacketHintSecondCell", bundle: nil), forCellReuseIdentifier: "HotBacketHintSecondCell")
        tableView.tableFooterView = UIView()
        self.view.addSubview(keyBoardView)
        self.keyBoardView.isHidden = true
       // self.currentType = .hotBacketType
        
        getDynamicDetail()
        
        //判断是心情还是活动，改变底部按钮
        if dynamicVCType == .moodType {
            //心情
            self.robhotbacketAndAttentActivityBtn.setTitle("抢红包", for: .normal)
        }else{
            //活动
            self.robhotbacketAndAttentActivityBtn.setTitle("报名", for: .normal)
        }
        //添加监听键盘的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: #selector(back))
        
       
        
    }
    @objc func back() -> Void {
        print("返回了")
        self.navigationController?.popViewController()
    }
    //键盘弹出
    @objc func keyBoardWillShow(_ aNotification:Notification) -> Void {
        print("键盘弹出")
        self.keyBoardView.isHidden = false
    }
    //键盘消失
    @objc func keyBoardWillHidden(_:Notification) -> Void {
        print("键盘消失")
        self.keyBoardView.isHidden = true
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return 1
        default:
            if dynamicVCType == .moodType {
                //心情
                if self.currentType == .commentType{
                    return self.commentListModel != nil ? self.commentTempArray.count:0
                }else if self.currentType == .zanType{
                    return self.likeListModel != nil ? self.zanTempArray.count:0
                }else{
                    guard self.alreadyHotBacketModel != nil else{
                        return 0
                    }
                    //判断红包cell的状态
                    if hotbacketAlreadyFinish == true && userIsRob == false && isHaveHotbacket == true {
                        //红包抢完且自己没抢
                        return 2 + self.alreadyHotBacketTempArray.count
                    }else if hotbacketAlreadyFinish == false && userIsRob == false && isHaveHotbacket == true{
                        //红包没抢完且自己没抢
                        return 1 + self.alreadyHotBacketTempArray.count
                    }else if userIsRob == true && isHaveHotbacket == true {
                        //自己抢了
                        return 2 + self.alreadyHotBacketTempArray.count
                    }
                    return self.alreadyHotBacketTempArray.count
                }
            }else{
                //活动
                if self.currentType == .commentType{
                    return self.commentListModel != nil ? self.commentTempArray.count:0
                }else if self.currentType == .zanType{
                    return self.likeListModel != nil ? self.zanTempArray.count:0
                }else{
                    return self.applyListModel != nil ? self.applyTempArray.count:0
                }
                
            }
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0:50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 15:0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCellDetail") as! DynamicCell
            if let dynamicDetailModel = self.dynamicDetailModel {
                let viewModel = DynamicDetailViewModel(listModel: dynamicDetailModel)
                cell.configerDynamicDetailCell(with: viewModel)
                cell.shareClickClosure = {
                    self.share(self.dynamicDetailModel)
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCommentCell") as! DynamicCommentCell
            if dynamicVCType == .moodType {
                //心情
                if self.currentType == .commentType{
                    //评论
                    let listModel:CommentListList = self.commentTempArray.object(at: indexPath.row) as! CommentListList
                    let viewModel = DynamicCommentViewModel(listModel: listModel)
                    cell.confingerCell(with: viewModel)
                }else if self.currentType == .zanType{
                    //点赞
                    let listModel:LikesList = self.zanTempArray.object(at: indexPath.row) as! LikesList
                    let viewModel = DynamicDetailZanViewModel(listModel: listModel)
                    cell.confingerCell(with: viewModel)
                }else{
                    //判断红包cell的状态
                    if hotbacketAlreadyFinish == true && userIsRob == false {
                         //红包抢完且自己没抢
                        if indexPath.row == 0 {
                            let firstCell = tableView.dequeueReusableCell(withIdentifier: "HotBacketHintCell") as! HotBacketHintCell
                            firstCell.robState = .noHaveRobed
                            firstCell.contentLabel.text = "很抱歉，您来晚了，红包抢完了！"
                            return firstCell
                        }else if indexPath.row == 1 {
                            let secondCell = tableView.dequeueReusableCell(withIdentifier: "HotBacketHintSecondCell") as! HotBacketHintSecondCell
                            secondCell.numOfalreadyMoney = String.init(format: "%0.2f",self.alreadyHotBacketModel.openMoney!)
                            secondCell.numOfAllMoney = String.init(format: "%0.2f", self.alreadyHotBacketModel.money!)
                            secondCell.numHotBacket = "\(self.numOfHotBacket)"
                            secondCell.allNumHotBacket = "\(self.numOfAllHotBacket)"
                            return secondCell
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCommentCell") as! DynamicCommentCell
                            let listModel:HotBacketListList = self.alreadyHotBacketTempArray.object(at: indexPath.row - 2) as! HotBacketListList
                            let viewModel = DynamicDetailRadBacketViewModel(listModel: listModel)
                            cell.confingerCell(with: viewModel)
                            return cell
                        }
                        
                    }else if hotbacketAlreadyFinish == false && userIsRob == false {
                        //红包没抢完且自己没抢
                        if indexPath.row == 0 {
                            let secondCell = tableView.dequeueReusableCell(withIdentifier: "HotBacketHintSecondCell") as! HotBacketHintSecondCell
                            secondCell.numOfalreadyMoney = String.init(format: "%0.2f",self.alreadyHotBacketModel.openMoney!)
                            secondCell.numOfAllMoney = String.init(format: "%0.2f", self.alreadyHotBacketModel.money!)
                            secondCell.numHotBacket = "\(self.numOfHotBacket)"
                            secondCell.allNumHotBacket = "\(self.numOfAllHotBacket)"
                            return secondCell
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCommentCell") as! DynamicCommentCell
                            let listModel:HotBacketListList = self.alreadyHotBacketTempArray.object(at: indexPath.row - 1) as! HotBacketListList
                            let viewModel = DynamicDetailRadBacketViewModel(listModel: listModel)
                            cell.confingerCell(with: viewModel)
                            return cell
                        }
                    }else if userIsRob == true {
                        //自己抢了
                        if indexPath.row == 0 {
                            let firstCell = tableView.dequeueReusableCell(withIdentifier: "HotBacketHintCell") as! HotBacketHintCell
                            firstCell.robState = .haveRobed
                            firstCell.numStr = String.init(format: "%0.2f", self.dynamicDetailModel.money!)
                            return firstCell
                        }else if indexPath.row == 1 {
                            let secondCell = tableView.dequeueReusableCell(withIdentifier: "HotBacketHintSecondCell") as! HotBacketHintSecondCell
                            secondCell.numOfalreadyMoney = String.init(format: "%0.2f",self.alreadyHotBacketModel.openMoney!)
                            secondCell.numOfAllMoney = String.init(format: "%0.2f", self.alreadyHotBacketModel.money!)
                            secondCell.numHotBacket = "\(self.numOfHotBacket)"
                            secondCell.allNumHotBacket = "\(self.numOfAllHotBacket)"
                            
                            return secondCell
                        }else{
                            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCommentCell") as! DynamicCommentCell
                            let listModel:HotBacketListList = self.alreadyHotBacketTempArray.object(at: indexPath.row - 2) as! HotBacketListList
                            let viewModel = DynamicDetailRadBacketViewModel(listModel: listModel)
                            cell.confingerCell(with: viewModel)
                            return cell
                        }
                    }
                }
                
                return cell
                
            }else{
                //活动
                if self.currentType == .commentType{
                    //评论
                    let listModel:CommentListList = self.commentTempArray.object(at: indexPath.row) as! CommentListList
                    let viewModel = DynamicCommentViewModel(listModel: listModel)
                    cell.confingerCell(with: viewModel)
                    
                }else if self.currentType == .zanType{
                    //点赞
                    let listModel:LikesList = self.zanTempArray.object(at: indexPath.row) as! LikesList
                    let viewModel = DynamicDetailZanViewModel(listModel: listModel)
                    cell.confingerCell(with: viewModel)

                }else{
                    let listModel:DynamicApplyListList = self.applyTempArray.object(at: indexPath.row) as! DynamicApplyListList
                    let viewModel = DynamicDetailApplyViewModel(listModel: listModel)
                    cell.confingerCell(with: viewModel)
                  
                }
                return cell
            }
    
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dynamicVCType == .moodType {
            if currentType == .hotBacketType {
                //判断红包cell的状态
                if hotbacketAlreadyFinish == true && userIsRob == false {
                    if indexPath.section == 1 {
                        return indexPath.row == 0 ? 70:UITableViewAutomaticDimension
                    }
                }else if hotbacketAlreadyFinish == false && userIsRob == false {
                    return UITableViewAutomaticDimension
                }else if userIsRob == true {
                    if indexPath.section == 1 {
                        return indexPath.row == 0 ? 70:UITableViewAutomaticDimension
                    }
               
                  }
            
                }
        
        }
        return UITableViewAutomaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
            return 2
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
    
    @IBAction func robHotbacketClick(_ sender: UIButton) {
        if self.dynamicVCType == .moodType {
            //抢红包
            if isCanRobHotbacket == false{
                SVProgressHUD.showInfo(withStatus: "没有红包可以抢了!")
            }else{
                robHotBacket({
                    //抢红包成功
                    
                    self.robhotbacketAndAttentActivityBtn.backgroundColor = UIColor(hex: "#CACACA")
                    self.userIsRob = true
                    self.isCanRobHotbacket = false
                    self.getDynamicDetail()
                    self.getAlreadyRobHotBacketList()
                })
            }
        }else{
            //报名
            if self.dynamicDetailModel.activity?.haveJoin == true {
                SVProgressHUD.showInfo(withStatus: "已报名")
            }else{
                let vc = ActivityEnrollController()
                vc.currentID = self.dynamicDetailModel.activity?.id
               // vc.headImageStr = self.dynamicDetailModel.member?.avatar
                vc.memberModel = self.dynamicDetailModel.member
                //需要传vc.type，0为官方活动1为个人活动，官方活动需要传vc.money
                vc.type = 1
                vc.back = {
                    self.getDynamicDetail()
                    self.getApplyList()
                    self.popSucceedViewForApply()
                }
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }

    }
//报名成功弹出框
    func popSucceedViewForApply() -> Void {
       let customView = ApplySucceedVIew.newInstance()
        let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: true)
        customAlert?.show()
    }
    
    @IBAction func commentClick(_ sender: UIButton) {
        self.keyBoardView.becomeFirstResponder()
    }
    @IBAction func zanClick(_ sender: UIButton) {
        zanImageView.animation = "pop"
        zanImageView2.animation = "pop"
        zanImageView.animate()
        zanImageView2.animate()
        zanAvtivity(dynamicId) {
            //点赞成功的操作
            if self.zanLabel.text == "点赞" {
                self.zanSucceed = true
                self.zanLabel.text = "已点赞"
                self.zanLabel.textColor = UIColor.red
                self.zanImageView.image = UIImage.init(named: "点赞（已点）")
                self.zanLabel2.text = "已点赞"
                self.zanLabel2.textColor = UIColor.red
                self.zanImageView2.image = UIImage.init(named: "点赞（已点）")
                
                
            }else{
                self.zanSucceed = false
                self.zanLabel.text = "点赞"
                self.zanLabel.textColor = UIColor.darkGray
                self.zanImageView.image = UIImage.init(named: "点赞（未点）")
                self.zanLabel2.text = "点赞"
                self.zanLabel2.textColor = UIColor.darkGray
                self.zanImageView2.image = UIImage.init(named: "点赞（未点）")
                
            }
            self.getLikeList()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
//接口
extension DynamicDetailVC{
    //报名
    func applyActivity(_ succeedClosure:@escaping (() -> ())) -> Void {
        startRequest(requestURLStr: activityApplyUrl, dic: ["commerce":1,"userToken":userToken(),"id":self.dynamicDetailModel.activity?.id! as Any,"money":0,"paytype":1], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                //报名成功
                self.popSucceedViewForApply()
                succeedClosure()
            }else{
                //报名失败
                print("报名失败")
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].string)
            }
            
        }) {
            
        }
    }
    
    //赞
    func zanAvtivity(_ activityId:NSInteger,_ resultClosure:@escaping () ->Void) -> Void {
        startRequest(requestURLStr: zanUrl, dic: ["commerce":1,"userToken":userToken(),"id":activityId], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("点赞成功")
                resultClosure()
                
            }else{
                print("点赞失败")
            }
        }) {
            
        }
    }
    //发表评论
    func publishComment() -> Void {
        startRequest(requestURLStr: commentOfDynamicUrl, dic: ["commerce":1,"userToken":userToken(),"id":dynamicId,"note":self.commentStr], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                //评论成功
                self.getCommentList()
                
            }else{
                //评论失败
                SVProgressHUD.showInfo(withStatus: "评论失败")
            }
            
        }) {
            
        }
    }
    //抢红包
    func robHotBacket(_ succeedClosure:@escaping () ->Void) -> Void {
        startRequest(requestURLStr: pullDownHotBacketUrl, dic: ["commerce":1,"userToken":userToken(),"id":self.dynamicDetailModel.packetId!], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
            //    SVProgressHUD.showSuccess(withStatus: "抢红包成功")
                GiFHUD.setGif("hongbao.gif")
                GiFHUD.showForSeconds(1)
                let time: TimeInterval = 1
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    succeedClosure()
                }
            }else{
                SVProgressHUD.showInfo(withStatus: "抢红包失败")
            }
        }) {
            
        }
    }
    //获取已经抢的红包列表
    func getAlreadyRobHotBacketList() -> Void {
        startRequest(requestURLStr: hotBacketListUrl, dic: ["id":dynamicId,"commerce":1,"userToken":userToken(),"no":1,"size":1000], actionHandler: { (jsonStr) in
            print("hotBacketListJson=\(jsonStr)")
            self.alreadyHotBacketModel = HotBacketListHotBacketListBassClass(json: jsonStr)
            self.alreadyHotBacketTempArray = NSMutableArray(array: self.alreadyHotBacketModel.list!)
            self.numOfHotBacket = self.alreadyHotBacketModel.total!
            if self.alreadyHotBacketModel.num != nil{
                self.numOfAllHotBacket = self.alreadyHotBacketModel.num!
                if self.numOfHotBacket == self.numOfAllHotBacket && self.numOfHotBacket != 0 {
                    //红包抢完（按钮不能点）
                    self.robhotbacketAndAttentActivityBtn.backgroundColor = UIColor(hex: "#CACACA")
                    self.hotbacketAlreadyFinish = true
                    self.isCanRobHotbacket = false
                }
            }
            
            if self.dynamicVCType == .activityType{
                self.segementView.setTitleArray(["报名 \(self.numOfApply)","评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }else if self.dynamicVCType == .moodType && self.dynamicDetailModel.haveRedPacket == false{
                //没有红包的心情
                self.currentType = .commentType
                self.segementView.setTitleArray(["评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }else{
                self.segementView.setTitleArray(["红包 \(self.numOfHotBacket)/\(self.numOfAllHotBacket)","评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }
            
            self.tableView.reloadData()
        }) {
            
        }
    }
    //获取动态详情
    func getDynamicDetail() -> Void {
        startRequest(requestURLStr: dynamicDetailUrl, dic: ["id":dynamicId,"commerce":1,"userToken":userToken()], actionHandler: { (jsonStr) in
            self.dynamicDetailModel = DynamicDetailDynamicDetailBassClass(json: jsonStr)
            //判断是否已赞
            if self.dynamicDetailModel.liked == true{
                self.zanLabel.text = "已点赞"
                self.zanLabel.textColor = UIColor.red
                self.zanImageView.image = UIImage.init(named: "点赞（已点）")
                self.zanLabel2.text = "已点赞"
                self.zanLabel2.textColor = UIColor.red
                self.zanImageView2.image = UIImage.init(named: "点赞（已点）")
            }
            self.isHaveHotbacket = self.dynamicDetailModel.haveRedPacket!
            print("self.dynamicDetailModel.haveRedPacket =\(self.dynamicDetailModel.haveRedPacket)")
            if self.dynamicDetailModel.haveRedPacket == false && self.dynamicVCType == .moodType {
                //没有红包则显示bottomView2
                self.bottomView2.isHidden = false
            }
            
            print("self.isHaveHotbacket = \(self.isHaveHotbacket)")
            if self.dynamicVCType == .activityType{
                //活动
                //判断是否报名
                if self.dynamicDetailModel.activity?.haveJoin == true {
                    //已报名
                    self.robhotbacketAndAttentActivityBtn.setTitle("已报名", for: .normal)
                    self.robhotbacketAndAttentActivityBtn.setTitleColor(UIColor.white, for: .normal)
                    self.robhotbacketAndAttentActivityBtn.backgroundColor = UIColor(hex: "#CACACA")
                }
            }else{
                //心情
                //判断是否有红包
                if self.dynamicDetailModel.haveRedPacket == false {
                    //没有红包
                      self.currentType = .commentType
                    self.robhotbacketAndAttentActivityBtn.backgroundColor = UIColor(hex: "#CACACA")
                    self.isCanRobHotbacket = false
                }
                //是否抢了红包
                self.userIsRob = self.dynamicDetailModel.opend!
                if self.userIsRob == true {
                    //抢过红包
                    self.robhotbacketAndAttentActivityBtn.backgroundColor = UIColor(hex: "#CACACA")
                    self.isCanRobHotbacket = false
                }
            }
           
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            self.getLikeList()
            self.getApplyList()
            if self.dynamicVCType == .activityType{
                //活动
                self.getCommentList()
            }else if self.dynamicVCType == .moodType && self.dynamicDetailModel.haveRedPacket == false{
                 self.getCommentList()
            }else{
                //心情
                self.getAlreadyRobHotBacketList()
                self.getCommentList()
            }
            //自动抢红包
            if self.autoRobHotBacket == true {
                //抢红包
                self.robHotbacketClick(UIButton())
                self.autoRobHotBacket = false
            }
        }) {
            
        }
    }
    //获取点赞列表数据
    func getLikeList() -> Void {
        startRequest(requestURLStr: likesUrl, dic: ["id":dynamicId,"commerce":1,"userToken":userToken(),"no":1,"size":1000], actionHandler: { (jsonStr) in
            self.likeListModel = LikesLikesBassClass(json: jsonStr)
            self.zanTempArray = NSMutableArray(array: self.likeListModel.list!)
            self.numOfZan = self.zanTempArray.count
            if self.dynamicVCType == .activityType{
                self.segementView.setTitleArray(["报名 \(self.numOfApply)","评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }else if self.dynamicVCType == .moodType && self.dynamicDetailModel.haveRedPacket == false{
                //没有红包的心情
                 //self.currentType = .zanType
                self.segementView.setTitleArray(["评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }else{
                self.segementView.setTitleArray(["红包 \(self.numOfHotBacket)/\(self.numOfAllHotBacket)","评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }
            self.tableView.reloadData()
        }) {
            
        }
    }
    //获取评论列表数据
    func getCommentList() -> Void {
        startRequest(requestURLStr: commentListUrl, dic: ["id":dynamicId,"commerce":1,"userToken":userToken(),"no":1,"size":1000], actionHandler: { (jsonStr) in
            self.commentListModel = CommentListCommentListBaseClass(json: jsonStr)
            self.commentTempArray = NSMutableArray(array: self.commentListModel.list!)
            self.numOfComment = self.commentTempArray.count
            if self.dynamicVCType == .activityType{
                self.segementView.setTitleArray(["报名 \(self.numOfApply)","评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }else if self.dynamicVCType == .moodType && self.dynamicDetailModel.haveRedPacket == false{
                //没有红包的心情
                  self.currentType = .commentType
                self.segementView.setTitleArray(["评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }else{
                self.segementView.setTitleArray(["红包 \(self.numOfHotBacket)/\(self.numOfAllHotBacket)","评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }
            self.tableView.reloadData()
        }) {
            
        }
    }
    //获取报名列表
    func getApplyList() -> Void {
        startRequest(requestURLStr: activityApplyListUrl, dic: ["id":dynamicId,"commerce":1,"userToken":userToken(),"no":1,"size":1000], actionHandler: { (jsonStr) in
            self.applyListModel = DynamicApplyListDynamicApplyList(json: jsonStr)
            self.applyTempArray = NSMutableArray(array: self.applyListModel.list!)
            self.numOfApply = self.applyTempArray.count
            if self.dynamicVCType == .activityType{
                self.segementView.setTitleArray(["报名 \(self.numOfApply)","评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }else if self.dynamicVCType == .moodType && self.dynamicDetailModel.haveRedPacket == false{
                //没有红包的心情
                  self.currentType = .commentType
                self.segementView.setTitleArray(["评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }else{
                self.segementView.setTitleArray(["红包 \(self.numOfHotBacket)/\(self.numOfAllHotBacket)","评论 \(self.numOfComment)","点赞 \(self.numOfZan)"], with: CBSegmentStyle.slider)
            }
            self.tableView.reloadData()
        }) {
            
        }
    }
}
extension DynamicDetailVC {
    func share(_ model:DynamicDetailDynamicDetailBassClass) {
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
extension DynamicDetailVC: WXDelegate {
    func shareSuccessByCode(_ code: Int) {
        if code == 0 {
            SVProgressHUD.showSuccess(withStatus: "分享成功")
        }
    }
}
