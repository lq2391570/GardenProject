//
//  MineController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class MineController: BaseViewController {

    var tableView = UITableView()
    var itemArr = [
        ["mine-intro","我的信息"],
        ["mine-wallet","我的钱包"],
        ["mine-activity","我的活动"],
        ["mine-pwd","修改密码"],
        ["mine-redpacket","红包记录"]
    ]
    var user: UserModel?
    var isLogin = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = getCurrentUser()
        if user?.name != nil {
            self.navigationItem.backBarButtonItem?.tintColor = .white
            isLogin = true
            showFooter()
            tableView.reloadData()
        }else {
            self.navigationItem.backBarButtonItem?.tintColor = navBarColor
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        create()
    }

}
extension MineController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isLogin ? 2 : 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : itemArr.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if isLogin {
                if user!.owner == true {
                    let cell = tableView.dequeueReusableCell(for: indexPath) as MineCompanyCell
                     cell.setData(user!)
                     cell.contentView.backgroundColor = navBarColor
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCell(for: indexPath) as MineInfoCell
                    cell.setData(user!)
                    cell.contentView.backgroundColor = navBarColor
                    return cell
                }
            }else {
                let cell = tableView.dequeueReusableCell(for: indexPath) as MineNoLoginCell
                cell.back = {
                    self.isLogin = true
                    tableView.reloadData()
                }
                return cell
            }
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as MineActionCell
            cell.logo.image = UIImage(named: itemArr[indexPath.row][0])
            cell.name.text = itemArr[indexPath.row][1]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            if isLogin == true {
                let vc = MineWalletController()
                navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
            let vc = ModifyPasswordController()
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = RpRecordsController()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            //我的活动
            let vc = MyActivityVC()
            navigationController?.pushViewController(vc, animated: true)
        case 0:
            //我的信息
            guard indexPath.section == 1 else { return }
            if isLogin == true {
            let vc = MyCirecleVC()
            vc.cirType = .MyMesType
            navigationController?.pushViewController(vc, animated: true)
            }
             
        default:
            break
        }
    }
}
extension MineController {
    func create() {
        
        tableView = UITableView(frame: .zero, style: .plain).then {
            $0.backgroundColor = backColor
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
              //  m.top.equalTo(navigationBarHeight)
                m.top.equalTo(0)
            })
            $0.register(cellType: MineInfoCell.self)
            $0.register(cellType: MineActionCell.self)
            $0.register(cellType: MineCompanyCell.self)
            $0.register(cellType: MineNoLoginCell.self)
            $0.delegate = self
            $0.dataSource = self
            //ios11可以不用设置estimatedRowHeight？
            $0.estimatedRowHeight = 200
        }
    }
    func showFooter() {
        let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 100))
        let submitBtn = UIButton(type: .custom)
        submitBtn.frame = CGRect(x: 60, y: 40, width: windowWidth-120, height: 50)
        submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        submitBtn.titleForNormal = "退出登录"
        submitBtn.titleColorForNormal = .white
        submitBtn.backgroundColor = UIColor.init(red: 172/255.0, green: 42/255.0, blue: 51/255.0, alpha: 1)
        submitBtn.addTarget(self, action: #selector(exit), for: .touchUpInside)
        bottomView.addSubview(submitBtn)
        tableView.tableFooterView = bottomView
    }
    @objc func exit() {
        SVProgressHUD.show()
        SVProgressHUD.dismiss(withDelay: 2, completion: {
            self.isLogin = false
            resetCurrentUser()
            self.tableView.tableFooterView = UIView()
            self.tableView.reloadData()
            //退出登陆后发通知
            let notifi = Notification.Name(rawValue: "loginOut")
            NotificationCenter.default.post(name: notifi, object: nil, userInfo: nil)
        
        })
    }
    
}
