//
//  ViewController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabbar()
        
    }
}
extension ViewController {
    func createTabbar() {
        let tabBarController = ESTabBarController()
        let v1 = FirstVC()
        let v2 = AddressBookVC()
        let v3 = MineController()
        
        v1.tabBarItem = ESTabBarItem(BasicContentView(), title: "首页", image: UIImage(named: "tabbar-home2"), selectedImage: UIImage(named: "tabbar-home-select2"))
        v2.tabBarItem = ESTabBarItem(BasicContentView(), title: "通讯录", image: UIImage(named: "tabbar-addressbook2"), selectedImage: UIImage(named: "tabbar-addressbook-select2"))
        v3.tabBarItem = ESTabBarItem(BasicContentView(), title: "我的", image: UIImage(named: "tabbar-mine2"), selectedImage: UIImage(named: "tabbar-mine-select2"))
        
        let n1 = BaseNavController(rootViewController: v1)
        let n2 = BaseNavController(rootViewController: v2)
        let n3 = BaseNavController(rootViewController: v3)
        
        v1.title = "首页"
        v2.title = "通讯录"
        v3.title = "我的"
        
        tabBarController.viewControllers = [n1, n2, n3]
        
        let myAppdelegate = UIApplication.shared.delegate as! AppDelegate
        myAppdelegate.window?.rootViewController = tabBarController
    }
}
class BasicContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor(hexString: "#666")!
        highlightTextColor = navBarColor!
        iconColor = UIColor(hexString: "#666")!
        highlightIconColor = navBarColor!
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
