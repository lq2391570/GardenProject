//
//  CommentCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/3.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
