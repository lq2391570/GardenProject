//
//  MyCirecleVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/13.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import MJRefresh
import UITableView_FDTemplateLayoutCell
import SVProgressHUD
import MPCoachMarks
class MyCirecleVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //圈子类型
    enum CirecleType {
        case MyCircleType    //我的圈子
        case userCircleType  //其他人的圈子
        case MyMesType       //我的信息
    }
    @IBOutlet var tableView: UITableView!
    var tempArray:NSMutableArray!
    var dynamiBassClass:ActivityActivityBassClass!
    var cirType:CirecleType!
    var userId = 0
    var currentPage = 2
    //顶部刷新    var header = MJRefreshHeader()
    //底部刷新
    var footer = MJRefreshFooter()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = cirType == .MyCircleType ? "我的圈子":"圈子"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CircleFirstCell", bundle: nil), forCellReuseIdentifier: "CircleFirstCell")
        tableView.register(UINib.init(nibName: "CircleSecondCell", bundle: nil), forCellReuseIdentifier: "CircleSecondCell")
        tableView.register(UINib.init(nibName: "DynamicCell", bundle: nil), forCellReuseIdentifier: "DynamicCell")
        self.tempArray = NSMutableArray(capacity: 0)
        self.tableView.mj_header = MJRefreshHeader.init(refreshingBlock: {
            print("刷新")
            self.getUserDynamic()
        })
        self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
            print("刷新")
            self.getUserDynamic()
        })
        self.tableView.mj_footer = setUpMJFooter(refreshingClosure: {
            print("加载更多")
           self.getMoreUserDynamic()
        })
        self.tableView.mj_header.beginRefreshing()
        self.getUserDynamic()
        let barButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: #selector(back))
        barButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = barButtonItem
        if cirType == CirecleType.MyCircleType {
            //我的圈子
            let userDefault = UserDefaults.standard
            let LoginState = userDefault.integer(forKey: "numOfLoginMyCycle")
            if LoginState != 1 {
              //  let time: TimeInterval = 0.5
                //查看是否为第一次进入我的圈子，是的话弹出引导
                //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    //code
                    print("0.5 秒后输出")
                    //添加一个引导页
                    self.addGuidePage()
//                }
//                userDefault.set(1, forKey: "numOfLoginMyCycle")
            }
        }
    }
    func addGuidePage() -> Void {
        let rect = tableView.rect(forSection: 1)
        
        print("rect = \(rect)")
        
        // print("rect2 = \(rect2)")
        let coachmark = CGRect.init(x: 0, y: rect.origin.y + 140  , width: rect.size.width + 20, height: rect.size.height + 40)
        
        let coachMarks = [["rect":NSValue.init(cgRect: coachmark),
                           "caption":"点击上方\n”发布心情“或”发布活动“",
                           "shape":NSNumber.init(value: 0),
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
    
    @objc func back() -> Void {
        self.navigationController?.popViewController()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if self.cirType == .MyCircleType {
            if indexPath.section == 0 {
                return 110
            }else if indexPath.section == 1 {
                return 90
            }else{
                
            }
            return tableView.fd_heightForCell(withIdentifier: "DynamicCell", cacheBy: indexPath, configuration: { (cell) in
                 let displayCell = cell as! DynamicCell
                let listModel:ActivityList = self.tempArray.object(at: indexPath.row) as! ActivityList
                let viewModel = MyCircleViewModel2(listModel: listModel)
                displayCell.confingerMyCircleCell(with: viewModel)

            })
        }else{
            if indexPath.section == 0 {
                return 110
            }
            return tableView.fd_heightForCell(withIdentifier: "DynamicCell", cacheBy: indexPath, configuration: { (cell) in
                let displayCell = cell as! DynamicCell
                let listModel:ActivityList = self.tempArray.object(at: indexPath.row) as! ActivityList
                let viewModel = MyCircleViewModel2(listModel: listModel)
                displayCell.confingerMyCircleCell(with: viewModel)

            })
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.cirType == .MyCircleType {
            if section == 0 {
                return 15
            }else if section == 1 {
                return 15
            }else{
                return 0
            }
        }else{
            return section == 0 ? 15:0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if cirType == .MyCircleType {
            return section==0 || section == 1 ? 1:tempArray.count
        }else{
            return section == 0 ? 1:tempArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if cirType == .MyCircleType {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CircleFirstCell") as! CircleFirstCell
                if self.dynamiBassClass != nil{
                    let viewModel = MyCircleViewModel1(dynamiBassClass: self.dynamiBassClass)
                    cell.configerCell(with: viewModel)
                }
                return cell
            }else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CircleSecondCell") as! CircleSecondCell
                cell.publishMoodClosure = { (btn) in
                    //发布心情
                    let vc = MoodPubViewController()
                    vc.back = { self.getUserDynamic() }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.publishActivityClosure = { (btn) in
                    //发布活动
                    let vc = ActivityPubViewController()
                    vc.back = { self.getUserDynamic() }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell") as! DynamicCell
                let listModel:ActivityList = self.tempArray.object(at: indexPath.row) as! ActivityList
                let viewModel = MyCircleViewModel2(listModel: listModel)
                cell.confingerMyCircleCell(with: viewModel)
                cell.messageBtnClickClosure = {(btn) in
                    print("点击msgBtn")
                    let listModel:ActivityList = self.tempArray.object(at: indexPath.row) as! ActivityList
                    let vc = DynamicDetailVC()
                    vc.dynamicId = listModel.id ?? 0
                    vc.dynamicVCType = listModel.catalog == 0 ? .activityType:.moodType
                    self.navigationController?.pushViewController(vc)
                }
                cell.zanBtnClickClosure = { (btn) in
                    print("点击赞")
                    //self.zanAvtivity(listModel.id ?? 0)
                    self.zanAvtivity(listModel.id ?? 0, {
                        //点赞成功的操作
                        if cell.zanImageView.image?.accessibilityIdentifier == "点赞（已点）"{
                            cell.zanImageView.image? = UIImage.init(named: "点赞（未点）")!
                             cell.zanImageView.image?.accessibilityIdentifier = "点赞（未点）"
                            cell.numOfZan = cell.numOfZan - 1
                            cell.zanNumLabel.text = "\(cell.numOfZan)"
                        }else{
                            cell.zanImageView.image? = UIImage.init(named: "点赞（已点）")!
                            cell.zanImageView.image?.accessibilityIdentifier = "点赞（已点）"
                            cell.numOfZan = cell.numOfZan + 1
                            cell.zanNumLabel.text = "\(cell.numOfZan)"
                        }
                    })
                }
                cell.shieldBtnClickClosure = { _ in
                    let alertSheet = UIAlertController.init(title: "提示", message: "您希望做以下操作", preferredStyle: .actionSheet)
                    let action1 = UIAlertAction(title: "屏蔽此条信息", style: .default, handler: { (action) in
                        print("屏蔽")
                        self.tempArray.removeObject(at: indexPath.row)
                        
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        
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
        }else{
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CircleFirstCell") as! CircleFirstCell
                if self.dynamiBassClass != nil{
                    let viewModel = MyCircleViewModel1(dynamiBassClass: self.dynamiBassClass)
                    cell.configerCell(with: viewModel)
                }
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicCell") as! DynamicCell
                let listModel:ActivityList = tempArray[indexPath.row] as! ActivityList
                let viewModel = MyCircleViewModel2(listModel: listModel)
                cell.confingerMyCircleCell(with: viewModel)
                cell.messageBtnClickClosure = {(btn) in
                    print("点击msgBtn")
                    let listModel:ActivityList = self.tempArray.object(at: indexPath.row) as! ActivityList
                    let vc = DynamicDetailVC()
                    vc.dynamicId = listModel.id ?? 0
                    vc.dynamicVCType = listModel.catalog == 0 ? .activityType:.moodType
                    self.navigationController?.pushViewController(vc)
                }
                cell.zanBtnClickClosure = { (btn) in
                    print("点击赞")
                    //self.zanAvtivity(listModel.id ?? 0)
                    self.zanAvtivity(listModel.id ?? 0, {
                        //点赞成功的操作
                        if cell.zanImageView.image?.accessibilityIdentifier == "点赞（已点）"{
                            cell.zanImageView.image? = UIImage.init(named: "点赞（未点）")!
                            cell.zanImageView.image?.accessibilityIdentifier = "点赞（未点）"
                            cell.numOfZan = cell.numOfZan - 1
                            cell.zanNumLabel.text = "\(cell.numOfZan)"
                        }else{
                            cell.zanImageView.image? = UIImage.init(named: "点赞（已点）")!
                            cell.zanImageView.image?.accessibilityIdentifier = "点赞（已点）"
                            cell.numOfZan = cell.numOfZan + 1
                            cell.zanNumLabel.text = "\(cell.numOfZan)"
                        }
                    })
                }
                cell.shieldBtnClickClosure = { _ in
                    let alertSheet = UIAlertController.init(title: "提示", message: "您希望做以下操作", preferredStyle: .actionSheet)
                    let action1 = UIAlertAction(title: "屏蔽此条信息", style: .default, handler: { (action) in
                        print("屏蔽")
                        self.tempArray.removeObject(at: indexPath.row)
                       
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
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
        }
    }
    
  func numberOfSections(in tableView: UITableView) -> Int
  {
    return self.cirType == .MyCircleType ? 3:2
  }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.cirType == .MyCircleType {
            //我的圈子
            if indexPath.section == 2 {
                let listModel:ActivityList = tempArray.object(at: indexPath.row) as! ActivityList
                let vc = DynamicDetailVC()
                vc.dynamicId = listModel.id ?? 0
                vc.dynamicVCType = listModel.catalog == 0 ? .activityType:.moodType
                self.navigationController?.pushViewController(vc)
            }
        }else{
            if indexPath.section == 1 {
                let listModel:ActivityList = tempArray.object(at: indexPath.row) as! ActivityList
                let vc = DynamicDetailVC()
                vc.dynamicId = listModel.id ?? 0
                vc.dynamicVCType = listModel.catalog == 0 ? .activityType:.moodType
                self.navigationController?.pushViewController(vc)
            }
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
//接口
extension MyCirecleVC{
    //获取某个用户的动态
    
    func getUserDynamic() -> Void {
        if self.cirType == .MyCircleType || self.cirType == .MyMesType {
            startRequest(requestURLStr: myDynamicUrl, dic: ["commerce":1,"userToken":userToken(),"no":1,"size":10], actionHandler: { (jsonStr) in
                print("cirecle = \(jsonStr)")
                self.dynamiBassClass = ActivityActivityBassClass(json: jsonStr)
                self.tempArray = NSMutableArray(array: self.dynamiBassClass.list!)
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.currentPage = 2
                self.tableView.mj_footer.resetNoMoreData()
            }, fail: {
                
            })
        }else{
            startRequest(requestURLStr: dynamicForUserUrl, dic: ["commerce":1,"userToken":userToken(),"user":userId,"no":1,"size":10], actionHandler: { (jsonStr) in
                 print("cirecle = \(jsonStr)")
                self.dynamiBassClass = ActivityActivityBassClass(json: jsonStr)
                self.tempArray = NSMutableArray(array: self.dynamiBassClass.list!)
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.currentPage = 2
                self.tableView.mj_footer.resetNoMoreData()
            }) {
                
            }
        }
    }
    //获取某用户的更多动态
    func getMoreUserDynamic() -> Void {
        if self.cirType == .MyCircleType || self.cirType == .MyMesType{
            startRequest(requestURLStr: myDynamicUrl, dic: ["commerce":1,"userToken":userToken(),"no":currentPage,"size":10], actionHandler: { (jsonStr) in
                self.dynamiBassClass = ActivityActivityBassClass(json: jsonStr)
                if self.dynamiBassClass.list?.count == 0 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.tempArray.addObjects(from: self.dynamiBassClass.list!)
                    self.currentPage = self.currentPage + 1
                    self.tableView.reloadData()
                    self.tableView.mj_footer.endRefreshing()
                }
            }, fail: {
                
            })
            
        }else{
            startRequest(requestURLStr: dynamicForUserUrl, dic: ["commerce":1,"userToken":userToken(),"user":userId,"no":currentPage,"size":10], actionHandler: { (jsonStr) in
                self.dynamiBassClass = ActivityActivityBassClass(json: jsonStr)
                if self.dynamiBassClass.list?.count == 0 {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.tempArray.addObjects(from: self.dynamiBassClass.list!)
                    self.currentPage = self.currentPage + 1
                    self.tableView.reloadData()
                    self.tableView.mj_footer.endRefreshing()
                }
                
            }) {
                
            }
        }
    
    }
    //点赞
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
}

