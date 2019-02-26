//
//  ProDetailCell2.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/23.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class ProDetailCell2: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var numOfPeopleLabel: UILabel!
    
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
    func confingerCell(with vm:ProjectDetailRespertable) -> Void {
        titleLabel.text = vm.titleName
        timeLabel.text = "时间:\(vm.dateStr)"
        numOfPeopleLabel.text = "人数:\(vm.numOfPeople)"
        contentLabel.text = vm.contentNote
    }
    
    
}
