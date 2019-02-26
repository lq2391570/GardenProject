//
//  HotBacketHintCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/26.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class HotBacketHintCell: UITableViewCell {

    @IBOutlet var contentLabel: UILabel!

    enum RobHotBacketState {
        case haveRobed  //抢到了红包
        case noHaveRobed //没抢到红包
    }
    var robState:RobHotBacketState = .haveRobed
    var numStr = ""
    var contentStr:String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        if self.robState == .haveRobed {
            //抢到了红包
            contentStr = "已领取：￥\(numStr)"
            
            let attrStr = NSMutableAttributedString(string: contentStr)
            let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:UIColor.darkGray]
            attrStr.addAttributes(attributes, range: NSRange.init(location: 0, length: 3))
            let attrbutes2 = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.foregroundColor:UIColor.red]
            attrStr.addAttributes(attrbutes2, range: NSRange.init(location: 4, length: 1))
            let attrbutes3 = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20),NSAttributedStringKey.foregroundColor:UIColor.red]
            attrStr.addAttributes(attrbutes3, range: NSRange.init(location: 5, length: contentStr.count - 5))
            contentLabel.attributedText = attrStr
            //   contentLabel.attributedText = NSAttributedString(string: str,attributes:attributes)
        }
        
    }
    
}
