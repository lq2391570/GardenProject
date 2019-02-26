//
//  MemberElegantCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/28.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class MemberElegantCell: UITableViewCell {

    @IBOutlet var headImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var phoneNumLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configerCell(with vm:MemberElegantRestable) -> Void {
        headImageView.sd_setImage(with: URL.init(string: vm.headImageStr), placeholderImage: UIImage.init(named: "加载图片"), options: .retryFailed, progress: nil, completed: nil)
        nameLabel.text = vm.nameStr
        phoneNumLabel.text = vm.phoneNumStr
        addressLabel.text = vm.addressStr
    }
    
}
