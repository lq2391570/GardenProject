//
//  AddressBookVC.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/3/29.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddressBookVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    var searBar:SearchView!
    var addressBookModel:AddressBookAddressBookBaseClass!
    var tempArray:NSMutableArray!
    var currentPage = 2
    var searchTempArray:NSMutableArray!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          self.navigationItem.backBarButtonItem?.tintColor = .white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "AddressBookCell", bundle: nil), forCellReuseIdentifier: "AddressBookCell")
        tableView.rowHeight = 80
        //searchBar
        let titleView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 60))
        self.searBar = SearchView.newInstance()
        searBar.searchBtnClickClosure = { (btn) in
            //搜索按钮
            print("点击搜索")
        }
        searBar.returnkeyClickClosure = { (textField) in
            //点击return
            print("点击return")
            self.searBar.searchTextField.resignFirstResponder()
        }
        titleView.addSubview(searBar)
        self.tableView.tableHeaderView = titleView
        self.tableView.tableFooterView = UIView()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        searchTempArray = NSMutableArray(capacity: 0)
        self.getAddressBookList()
    }
    
    @objc func textFieldChange(_ aNotification:Notification) -> Void {
        print("输入\(self.searBar.searchTextField.text)")
        searchTempArray.removeAllObjects()
        for model in tempArray {
            let listModel:AddressBookList = model as! AddressBookList
            if ((listModel.name ?? "") .contains(searBar.searchTextField.text!)) {
                if searchTempArray.contains(listModel) == false{
                    searchTempArray.add(listModel)
                }
            }
        }
        self.tableView.reloadData()
    }
    //获取联系人
    func getAddressBookList() -> Void {
        startRequest(requestURLStr: AddressBookListURL, dic: ["commerce":1,"userToken":userToken()], actionHandler: { (jsonStr) in
            self.addressBookModel = AddressBookAddressBookBaseClass(json: jsonStr)
            self.tempArray = NSMutableArray(array: self.addressBookModel.list!)
            self.tableView.reloadData()
        }) {
            
        }
    }
    //获取更多联系人
    func getMoreAddressBookList() -> Void {
        startRequest(requestURLStr: AddressBookListURL, dic: ["commerce":1,"userToken":userToken()], actionHandler: { (jsonStr) in
            self.addressBookModel = AddressBookAddressBookBaseClass(json: jsonStr)
            if self.addressBookModel.list?.count == 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.tempArray.addObjects(from: self.addressBookModel.list!)
                self.currentPage = self.currentPage + 1
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
            }
        }) {
            
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searBar .resignFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.addressBookModel != nil ? (self.searBar.searchTextField.text != "" ? searchTempArray.count:tempArray.count) : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressBookCell") as! AddressBookCell
        let listModel:AddressBookList
        listModel = self.searBar.searchTextField.text != "" ? searchTempArray.object(at: indexPath.row) as! AddressBookList : tempArray.object(at: indexPath.row) as! AddressBookList
        cell.phoneBtnClickClosure = { (btn) in
            let alertVC:UIAlertController = UIAlertController.init(title: "是否拨打电话", message: "", preferredStyle: .alert)
            let action1 = UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
                //拨打电话
                judgeUserState { (state) in
                    if state == 4 {
                        //未登录
                     //   SVProgressHUD.showInfo(withStatus: "请登录")
                        let vc = LoginController()
                        self.navigationItem.backBarButtonItem?.tintColor = navBarColor
                        self.navigationController?.pushViewController(vc)
                    }else{
                        if listModel.phone == nil {
                            SVProgressHUD.showInfo(withStatus: "此用户暂无电话")
                        }else{
                            UIApplication.shared.openURL(URL.init(string: "tel://\(listModel.phone!)")!)
                        }
                    }
                }
                
            })
            let action2 = UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
                
            })
            alertVC.addAction(action1)
            alertVC.addAction(action2)
            self.present(alertVC, animated: true, completion: nil)
            
        }
        let viewModel = AddressBookViewModel(listModel: listModel)
        cell.confingerCell(with: viewModel)
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        judgeUserState { (state) in
            if state == 4 {
                //未登录
            //     SVProgressHUD.showInfo(withStatus: "请登录")
                let vc = LoginController()
                self.navigationItem.backBarButtonItem?.tintColor = navBarColor
                self.navigationController?.pushViewController(vc)
            }else{
                let vc = MyCirecleVC()
                let listModel:AddressBookList = self.tempArray.object(at: indexPath.row) as! AddressBookList
                vc.cirType = .userCircleType
                vc.userId = listModel.id!
                self.navigationController?.pushViewController(vc)
            }
        }
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
