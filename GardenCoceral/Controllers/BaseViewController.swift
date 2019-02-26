//
//  BaseViewController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/3/26.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import Then
import Kingfisher

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    let service = MyService.shareInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(back))
        barButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = barButtonItem
        

        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barStyle = .black;
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()

        
        if #available(iOS 11.0, *) {
            //tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    
    }
    @objc func back() -> Void {
        self.navigationController?.popViewController()
    }

}
extension BaseViewController {
    //状态栏类型
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
