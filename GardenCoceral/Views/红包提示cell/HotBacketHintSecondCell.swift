//
//  HotBacketHintSecondCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/26.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class HotBacketHintSecondCell: UITableViewCell {

    @IBOutlet var moneyLabel: UILabel!
    
    @IBOutlet var numOfHotBacket: UILabel!
    var numOfalreadyMoney = ""
    var numOfAllMoney = ""
    var moneyOfhotbacket = ""
    
    var numHotBacket = ""
    var allNumHotBacket = ""
    var numOfHotBacketStr = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        moneyOfhotbacket = "红包金额：￥\(numOfalreadyMoney)/￥\(numOfAllMoney)"
        let attrStr = NSMutableAttributedString(string: moneyOfhotbacket)
        let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.darkGray]
        attrStr.addAttributes(attributes, range: NSRange.init(location: 0, length: 5))
        let attrbutes2 = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.init(red: 152/255.0, green: 175/255.0, blue: 145/255.0, alpha: 1)]
        attrStr.addAttributes(attrbutes2, range: NSRange.init(location: 5, length: numOfalreadyMoney.count + 1))
        let attrbutes3 = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.init(red: 244/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1)]
        attrStr.addAttributes(attrbutes3, range: NSRange.init(location:  numOfalreadyMoney.count + 6, length: numOfAllMoney.count + 2))
        moneyLabel.attributedText = attrStr
        // Configure the view for the selected state
        
        numOfHotBacketStr = "\(numHotBacket)/\(allNumHotBacket)"
        let hattrStr = NSMutableAttributedString(string: numOfHotBacketStr)
        let hattributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.init(red: 45/255.0, green: 188/255.0, blue: 38/255.0, alpha: 1)]
        hattrStr.addAttributes(hattributes, range: NSRange.init(location: 0, length: numHotBacket.count))
        let hattrbutes2 = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.darkGray]
        hattrStr.addAttributes(hattrbutes2, range: NSRange.init(location: numHotBacket.count, length: allNumHotBacket.count + 1))
        numOfHotBacket.attributedText = hattrStr
        
        
        
        
    }
    
}
