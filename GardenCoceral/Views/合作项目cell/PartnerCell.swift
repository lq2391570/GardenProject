//
//  PartnerCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/22.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class PartnerCell: UITableViewCell {

    @IBOutlet var bigImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with vm:PartnerRepresentable) -> Void {
        bigImageView.sd_setImage(with: URL.init(string: vm.headImageStr), placeholderImage: UIImage.init(named: "加载图片"), options: .retryFailed, progress: nil, completed: nil)
        titleLabel.text = vm.titleStr
        descLabel.text = vm.descStr
        dateLabel.text = vm.dateStr
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
