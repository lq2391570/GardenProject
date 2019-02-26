//
//  PartnerVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/22.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class PartnerVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var bassClass:ProjectProjectBaseClass!
    var viewModel:PartnerViewModel!
    var currentPage = 2
    var tempArray:NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "合作项目"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "PartnerCell", bundle: nil), forCellReuseIdentifier: "PartnerCell")
        tableView.rowHeight = 300
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
         tempArray = NSMutableArray.init(capacity: 0)
        self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
           self.getProjectList()
        })
        self.tableView.mj_footer = setUpMJFooter(refreshingClosure: {
            print("加载更多")
            self.getMoreProjectList()
        })
        self.tableView.mj_header.beginRefreshing()
        
        getProjectList()
    }
    
    
    
    
    //获取合作项目列表
    func getProjectList() -> Void {
        startRequest(requestURLStr: projectListUrl, dic: ["commerce":1,"userToken":userToken(),"no":1,"size":10], actionHandler: { (jsonStr) in
            print("proJsonStr = \(jsonStr)")
            self.bassClass = ProjectProjectBaseClass(json: jsonStr)
            self.tempArray = NSMutableArray(array: self.bassClass.list!)
            
            self.tableView.reloadData()
            self.currentPage = 2
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.resetNoMoreData()
        }) {
            
        }
    }
    //获取更多合作项目列表
    func getMoreProjectList() -> Void {
        startRequest(requestURLStr: projectListUrl, dic: ["commerce":1,"userToken":userToken(),"no":currentPage,"size":10], actionHandler: { (jsonStr) in
            print("proJsonStr = \(jsonStr)")
            if self.bassClass.list?.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.bassClass = ProjectProjectBaseClass(json: jsonStr)
                self.tempArray.addObjects(from: self.bassClass.list!)
               self.currentPage = self.currentPage + 1
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }
        }) {
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.bassClass != nil ? self.tempArray.count : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartnerCell") as! PartnerCell
        let listModel:ProjectList = tempArray.object(at: indexPath.row) as! ProjectList
        viewModel = PartnerViewModel(projectListModel: listModel)
        cell.configure(with: viewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let listModel:ProjectList =  tempArray.object(at: indexPath.row) as! ProjectList
        let vc = ProjectDetailVC()
        vc.projectId = listModel.id ?? 0
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
