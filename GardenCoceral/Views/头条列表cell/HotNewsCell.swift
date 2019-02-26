//
//  HotNewsCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/25.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class HotNewsCell: UITableViewCell {

    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //调整行间距
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 15
        let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.paragraphStyle:paraph]
        contentLabel.attributedText = NSAttributedString(string: contentLabel.text!,attributes:attributes)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
