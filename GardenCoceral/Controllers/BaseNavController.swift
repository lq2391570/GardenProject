//
//  BaseNavController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class BaseNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count>0 {
            
            viewController.hidesBottomBarWhenPushed = true //跳转之后隐藏
        }
        
        super.pushViewController(viewController, animated: true)
    }
}
