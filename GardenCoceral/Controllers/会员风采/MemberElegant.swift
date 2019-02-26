//
//  MemberElegant.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/28.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class MemberElegant: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var tempArray:NSMutableArray!
    var memberElegantBassClass:MemberElegantMemberElegantBassClass!
    //当前页
    var currentPage = 2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "企业风采"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "MemberElegantCell", bundle: nil), forCellReuseIdentifier: "MemberElegantCell")
        // Do any additional setup after loading the view.
        tempArray = NSMutableArray.init(capacity: 0)
        
        self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
               self.getMemberElegantList()
        })
        self.tableView.mj_footer = setUpMJFooter(refreshingClosure: {
              print("加载更多")
            self.getMoreMemberElegantList()
        })
        self.tableView.mj_header.beginRefreshing()
        
        getMemberElegantList()
    }
    
    
    
    //获取会员风采
    func getMemberElegantList() -> Void {
        startRequest(requestURLStr: memberElegantUrl, dic: ["commerce":1,"userToken":userToken(),"no":1,"size":10], actionHandler: { (jsonStr) in
            self.memberElegantBassClass = MemberElegantMemberElegantBassClass(json: jsonStr)
            self.tempArray = NSMutableArray(array: self.memberElegantBassClass.list!)
            self.tableView.reloadData()
            self.currentPage = 2
            self.tableView.mj_header.endRefreshing()
             self.tableView.mj_footer.resetNoMoreData()
        }) {
            
        }
    }
    //获取更多会员风采
    func getMoreMemberElegantList() -> Void {
        startRequest(requestURLStr: memberElegantUrl, dic: ["commerce":1,"userToken":userToken(),"no":currentPage,"size":10], actionHandler: { (jsonStr) in
            
            if self.memberElegantBassClass.list?.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.memberElegantBassClass = MemberElegantMemberElegantBassClass(json: jsonStr)
                self.tempArray.addObjects(from: self.memberElegantBassClass.list!)
                self.currentPage = self.currentPage + 1
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }
            
          
        }) {
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.memberElegantBassClass != nil ? self.tempArray.count:0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberElegantCell") as! MemberElegantCell
        let listModel:MemberElegantList = tempArray.object(at: indexPath.row) as! MemberElegantList
        let viewModel:MemberElegantViewModel = MemberElegantViewModel(listModel: listModel)
        cell.configerCell(with: viewModel)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BriefWebVC()
        let listModel:MemberElegantList = tempArray.object(at: indexPath.row) as! MemberElegantList
        vc.vipId = listModel.id!
        vc.webType = .elegantType
        self.navigationController?.pushViewController(vc)
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
