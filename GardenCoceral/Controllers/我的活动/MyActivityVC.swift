//
//  MyActivityVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/20.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MyActivityVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    enum MyPubOrMyJoinType:Int {
        case myPublish = 0
        case myJoin
    }
    
    @IBOutlet var tableView: UITableView!
    var myPublishTempArray:NSMutableArray!
    var myJoinTempArray:NSMutableArray!
    @IBOutlet var titleView: UIView!
    var myMyPubBassClass:MyPublishMyPublishbassClass!
    var myMyJoinBassClass:MyPublishMyPublishbassClass!
    var arrayType:MyPubOrMyJoinType!
    var currentPubPage = 2
    var currentJoinPage = 2
    
    //懒加载一个headerView
    lazy var segment = { ()->CBSegmentView2 in
        let seg = CBSegmentView2(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 50))
        seg.backgroundColor = UIColor.white
        seg.setTitleArray(["我发起的","我参与的"], titleFont: 15, titleColor: UIColor(hexString: "#999"), titleSelectedColor: themeColor, with: .styleSlider2)
        seg.titleChooseReturn = { (index) in
            self.arrayType = index == 0 ? .myPublish:.myJoin
            self.tableView.reloadData()
        }
        return seg
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的活动"
        // Do any additional setup after loading the view.
        self.myPublishTempArray = NSMutableArray(capacity: 0)
        self.myJoinTempArray = NSMutableArray(capacity: 0)
       
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "DynamicCell", bundle: nil), forCellReuseIdentifier: "DynamicCell")
        arrayType = MyPubOrMyJoinType.myPublish
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(back))
        barButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = barButtonItem
        self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
            if self.arrayType == MyPubOrMyJoinType.myPublish {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.emptyDataSetSource = self
                self.tableView.emptyDataSetDelegate = self
                self.getMyPublishActivity()
            }else{
                self.getMyJoinActivity()
            }
        })
        self.tableView.mj_footer = setUpMJFooter(refreshingClosure: {
            print("加载更多")
            if self.arrayType == MyPubOrMyJoinType.myPublish {
                self.getMoreMyPublishActivity()
            }else{
                self.getMoreMyJoinActivity()
            }
        })
        getMyPublishActivity()
        getMyJoinActivity()
        self.tableView.mj_header.beginRefreshing()
    }
    @objc func back() -> Void {
        self.navigationController?.popViewController()
    }
    //创建选择栏
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? segment:nil
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "暂无数据哦"
        let paraph = NSMutableParagraphStyle()
        paraph.alignment = .center
        let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17),NSAttributedStringKey.paragraphStyle:paraph]
        let attrStr = NSAttributedString(string: str, attributes: attributes)
        return attrStr
    }
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "暂无数据（图标）")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: "DynamicCell", cacheBy: indexPath, configuration: { (cell) in
            let displayCell = cell as! DynamicCell
            var listModel:MyPublishList!
            if self.arrayType == MyPubOrMyJoinType.myPublish{
                 listModel = self.myPublishTempArray.object(at: indexPath.row) as! MyPublishList
            }else{
                listModel = self.myJoinTempArray.object(at: indexPath.row) as! MyPublishList
            }
            let vm = MyActivityViewModel(listModel: listModel)
            displayCell.confingerCell3(with: vm)
        })
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 50:0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayType == MyPubOrMyJoinType.myPublish ? self.myPublishTempArray.count:self.myJoinTempArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell") as! DynamicCell
        let listModel:MyPublishList!
        if self.arrayType == MyPubOrMyJoinType.myPublish {
            listModel = self.myPublishTempArray.object(at: indexPath.row) as! MyPublishList
        }else{
            listModel = self.myJoinTempArray.object(at: indexPath.row) as! MyPublishList
        }
        let vm = MyActivityViewModel(listModel: listModel)
        cell.confingerCell3(with: vm)
        cell.messageBtnClickClosure = {(btn) in
            print("点击msgBtn")
            let listModel:MyPublishList!
            if self.arrayType == MyPubOrMyJoinType.myPublish {
                listModel = self.myPublishTempArray.object(at: indexPath.row) as! MyPublishList
            }else{
                listModel = self.myJoinTempArray.object(at: indexPath.row) as! MyPublishList
            }
            let vc = DynamicDetailVC()
            vc.dynamicId = listModel.feedId ?? 0
            //活动
            vc.dynamicVCType = .activityType
            self.navigationController?.pushViewController(vc)
        }
        cell.zanBtnClickClosure = { (btn) in
            print("点击赞")
           
            self.zanAvtivity(listModel.feedId ?? 0, {
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
        return cell
    }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listModel:MyPublishList!
        if self.arrayType == MyPubOrMyJoinType.myPublish {
            listModel = self.myPublishTempArray.object(at: indexPath.row) as! MyPublishList
        }else{
            listModel = self.myJoinTempArray.object(at: indexPath.row) as! MyPublishList
        }
        let vc = DynamicDetailVC()
        vc.dynamicId = listModel.feedId ?? 0
        vc.dynamicVCType = .activityType
        self.navigationController?.pushViewController(vc)
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
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
extension MyActivityVC{
    //我发布的活动
    func getMyPublishActivity() -> Void {
        startRequest(requestURLStr: myPublishUrl, dic: ["commerce":1,"userToken":userToken(),"no":1,"size":10], actionHandler: { (jsonStr) in
            self.myMyPubBassClass = MyPublishMyPublishbassClass(json: jsonStr)
            
            if let myPubBassClasslist = self.myMyPubBassClass.list{
                self.myPublishTempArray = NSMutableArray(array: myPubBassClasslist)
            }
           
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.currentPubPage = 2
            self.tableView.mj_footer.resetNoMoreData()
        }) {
            
        }
    }
    //更多我发布的活动
    func getMoreMyPublishActivity() -> Void {
        startRequest(requestURLStr: myPublishUrl, dic: ["commerce":1,"userToken":userToken(),"no":currentPubPage,"size":10], actionHandler: { (jsonStr) in
            self.myMyPubBassClass = MyPublishMyPublishbassClass(json: jsonStr)
            if self.myMyPubBassClass.list?.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.myPublishTempArray.addObjects(from: self.myMyPubBassClass.list!)
                self.currentPubPage = self.currentPubPage + 1
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }
        }) {
            
        }
    }
    //我参与的活动
    func getMyJoinActivity() -> Void {
        startRequest(requestURLStr: myJoinUrl, dic: ["commerce":1,"userToken":userToken(),"no":1,"size":10], actionHandler: { (jsonStr) in
            self.myMyJoinBassClass = MyPublishMyPublishbassClass(json: jsonStr)
            if let myJoinBassClassList = self.myMyJoinBassClass.list{
                self.myJoinTempArray = NSMutableArray(array: myJoinBassClassList)
            }
            
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.currentJoinPage = 2
            self.tableView.mj_footer.resetNoMoreData()
        }) {
            
        }
    }
    //更多我参与的活动
    func getMoreMyJoinActivity() -> Void {
        startRequest(requestURLStr: myJoinUrl, dic: ["commerce":1,"userToken":userToken(),"no":currentJoinPage,"size":10], actionHandler: { (jsonStr) in
            self.myMyJoinBassClass = MyPublishMyPublishbassClass(json: jsonStr)
            if self.myMyJoinBassClass.list?.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.myJoinTempArray.addObjects(from: self.myMyJoinBassClass.list!)
                self.currentJoinPage = self.currentJoinPage + 1
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }
        }) {
            
        }
    }
}

