//
//  LQSearchBar.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/3/29.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class LQSearchBar: UISearchBar {

    var placeholderStr:String!
    var height2:CGFloat = 0.0
    var newCornerRadius:CGFloat!
    
    override func layoutSubviews() -> Void {
        super.layoutSubviews()
        var searchField:UITextField!
        let subviewArr = self.subviews
        for i in 0..<subviewArr.count {
            let viewSub = subviewArr[i]
            let arrSub = viewSub.subviews
            for j in 0..<arrSub.count {
                let tempId = arrSub[j]
                if tempId.isKind(of: UITextField.classForCoder()){
                    searchField = tempId as! UITextField
                }
            }
        }
        //自定义UISearchBar
        if (searchField != nil) {
            searchField.placeholder = "搜索"
            searchField.borderStyle = .none
            searchField.backgroundColor = UIColor.gray
            searchField.textAlignment = .left
            searchField.textColor = UIColor.black
            searchField.bounds = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: CGFloat(self.height2))
            searchField.layer.masksToBounds = true
            searchField.layer.cornerRadius = self.newCornerRadius
        }
        let searchTextField = self.subviews.first?.subviews.last
        self.barTintColor = UIColor.white
        searchTextField?.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        //消除边框
        self.backgroundImage = UIImage()
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
