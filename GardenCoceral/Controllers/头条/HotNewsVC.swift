//
//  HotNewsVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/25.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class HotNewsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{

    @IBOutlet var tableView: UITableView!
    var tempArray:NSMutableArray!
    var hotArticleBassClass:HotArticleHotArticleBassClass!
    var currentPage = 2
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "头条"
        tableView.rowHeight = 110
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "HotNewsCell", bundle: nil), forCellReuseIdentifier: "HotNewsCell")
        tempArray = NSMutableArray(capacity: 0)
        self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            self.getHotNewsList()
        })
        self.tableView.mj_header.beginRefreshing()
        self.tableView.mj_footer = setUpMJFooter(refreshingClosure: {
            print("加载更多")
            self.getMoreHotNewsList()
        })
        let barButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: #selector(back))
        barButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = barButtonItem
        // Do any additional setup after loading the view.
        getHotNewsList()
    }
    @objc func back() -> Void {
        self.navigationController?.popViewController()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tempArray.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HotNewsCell") as! HotNewsCell
    let listModel:HotArticleList = tempArray.object(at: indexPath.row) as! HotArticleList
    cell.titleLabel.text = listModel.title
    cell.contentLabel.text = listModel.note
    return cell
   }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listModel:HotArticleList = tempArray.object(at: indexPath.row) as! HotArticleList
        let vc = ArticleWebVC()
        vc.webId = listModel.id!
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
extension HotNewsVC{
    //获取头条文章
    func getHotNewsList() -> Void {
        startRequest(requestURLStr: hotArticleUrl, dic: ["commerce":1,"userToken":userToken(),"no":1,"size":6], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                self.hotArticleBassClass = HotArticleHotArticleBassClass(json: jsonStr)
                self.tempArray.addObjects(from: self.hotArticleBassClass.list!)
                self.tableView.reloadData()
                self.tableView.mj_header.endRefreshing()
                self.currentPage = 2
                self.tableView.mj_footer.resetNoMoreData()
            }
            
        }) {
            
        }
    }
    //获取更多头条文章
    func getMoreHotNewsList() -> Void {
        startRequest(requestURLStr: hotArticleUrl, dic: ["commerce":1,"userToken":userToken(),"no":currentPage,"size":6], actionHandler: { (jsonStr) in
            self.hotArticleBassClass = HotArticleHotArticleBassClass(json: jsonStr)
            if self.hotArticleBassClass.list?.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.tempArray.addObjects(from: self.hotArticleBassClass.list!)
                self.currentPage = self.currentPage + 1
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }
        }) {
            
        }
    }
}
