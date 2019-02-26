//
//  UserBtn.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/12.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class UserBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    var cirTypeNum:Int = 0
    var userId:Int = 0
    
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        self.addTarget(self, action: #selector(userBtnClick), for: .touchUpInside)
    }
    @objc func userBtnClick() -> Void {
        skipTo(cirTypeNum: self.cirTypeNum, userId: self.userId)
    }
    func skipTo(cirTypeNum:Int,userId:Int) -> Void {
        let vc = MyCirecleVC()
        vc.cirType = .userCircleType
        vc.userId = userId
        parentViewController?.navigationController?.pushViewController(vc)
    }
    
    
    

}
