//
//  ApplyListCell1.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/23.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class ApplyListCell1: UITableViewCell {

    var numOfApply:Int = 0
    
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  titleLabel.text = "已报名的人(\(numOfApply))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
