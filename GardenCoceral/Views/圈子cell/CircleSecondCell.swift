//
//  CircleSecondCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/13.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class CircleSecondCell: UITableViewCell {

    var publishMoodClosure:((UIButton) -> ())?
    var publishActivityClosure:((UIButton) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
    }
    //发布心情
    @IBAction func publishMoodClick(_ sender: UIButton) {
        if self.publishMoodClosure != nil {
            self.publishMoodClosure!(sender)
        }
    }
    //发布活动
    @IBAction func publishArtivityClick(_ sender: UIButton) {
        if self.publishActivityClosure != nil {
            self.publishActivityClosure!(sender)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
