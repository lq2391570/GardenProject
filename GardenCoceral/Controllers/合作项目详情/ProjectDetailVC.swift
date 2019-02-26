//
//  ProjectDetailVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/23.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD
class ProjectDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var alreadyApplyBtn: UIButton!
    
    @IBOutlet var goToApplyBtn: UIButton!
    
    var bgView:UIView!
    
    var proDetailBassClass:ProjectDetailProjectDetailBaseClass!
    
    var projectId:Int = 0
    
    @IBOutlet var arrowImageView: UIImageView!
    
    
    lazy var bottomTableView:ApplyListView = { () -> ApplyListView in
        let bottomTableView = ApplyListView.newInstance()
        bottomTableView.bassclass = self.proDetailBassClass
        return bottomTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "ProDetailCell1", bundle: nil), forCellReuseIdentifier: "ProDetailCell1")
        tableView.register(UINib.init(nibName: "ProDetailCell2", bundle: nil), forCellReuseIdentifier: "ProDetailCell2")
        // Do any additional setup after loading the view.
        getProjectDetail(proId: self.projectId)
        //背景View
        bgView = UIView(frame: CGRect.init(x: 0, y: 0, width: windowWidth, height: windowHeight))
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.5
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(bgTapClick))
        bgView.isUserInteractionEnabled = true
        bgView.addGestureRecognizer(tapRecognizer)
        tableView.addSubview(bgView)
        bgView.isHidden = true
        alreadyApplyBtn.isSelected = false
    }
    @objc func bgTapClick() -> Void {
        self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: 0)
        self.bgView.isHidden = true
        self.bottomTableView.frame = CGRect.init(x: 0, y: windowHeight, width: windowWidth, height: 317)
        self.alreadyApplyBtn.isSelected = false
    }
    //获取项目详情
    func getProjectDetail(proId:Int) -> Void {
        startRequest(requestURLStr: projectDetailUrl, dic: ["commerce":1,"userToken":userToken(),"id":proId], actionHandler: { (jsonStr) in
            print("proDetailJson = \(jsonStr)")
            self.proDetailBassClass = ProjectDetailProjectDetailBaseClass(json: jsonStr)
            self.bottomTableView.frame = CGRect.init(x: 0, y: windowHeight, width: windowWidth, height: 317)
            self.tableView.addSubview(self.bottomTableView)
            self.view.bringSubview(toFront: self.alreadyApplyBtn)
            self.view.bringSubview(toFront: self.goToApplyBtn)
            if self.proDetailBassClass.haveJoin == true {
                //已报名
                self.goToApplyBtn.setTitle("已报名", for: .normal)
                self.goToApplyBtn.setTitleColor(UIColor.white, for: .normal)
                self.goToApplyBtn.backgroundColor = UIColor(hex: "#CACACA")
            }
            
            self.tableView.reloadData()
        }) {
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 170
        }else{
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProDetailCell1") as! ProDetailCell1
            guard self.proDetailBassClass != nil else {
                return cell
            }
            let viewModel = projectDetailViewModel(projectDetailBassClass: self.proDetailBassClass)
            cell.configerCell(with: viewModel)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProDetailCell2") as! ProDetailCell2
            guard self.proDetailBassClass != nil else {
                return cell
            }
            let viewModel = projectDetailViewModel(projectDetailBassClass: self.proDetailBassClass)
            cell.confingerCell(with: viewModel)
            return cell
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func applyListBtnClick(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3) {
            
            if sender.isSelected == true {
                 self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: 0)
                self.bgView.isHidden = true
                self.bottomTableView.frame = CGRect.init(x: 0, y: windowHeight, width: windowWidth, height: 317)
                sender.isSelected = false
            }else{
                self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI))
                self.bgView.isHidden = false
                if isIphoneX {
                    self.bottomTableView.frame = CGRect.init(x: 0, y: self.tableView.frame.size.height-317, width: windowWidth, height: 317)
                }else{
                    self.bottomTableView.frame = CGRect.init(x: 0, y: self.tableView.frame.size.height-317, width: windowWidth, height: 317)
                }
                sender.isSelected = true
            }
        }
        
    }
    
    @IBAction func applyBtnClick(_ sender: UIButton) {
        
        if self.proDetailBassClass.haveJoin == true {
            SVProgressHUD.showInfo(withStatus: "已报名")
            return
        }
        let vc = ActivityEnrollController()
        vc.currentID = self.projectId
        //需要传vc.type，0为官方活动1为个人活动2为项目，官方活动需要传vc.money
        vc.type = 2
        vc.money = proDetailBassClass.money?.double ?? 0
        vc.back = {
            self.getProjectDetail(proId: self.projectId)
        }
        navigationController?.pushViewController(vc, animated: true)
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
