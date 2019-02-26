//
//  ProDetailCell1.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/23.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class ProDetailCell1: UITableViewCell {

    @IBOutlet var headImageVieew: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configerCell(with vm:ProjectImageRespertable) -> Void {
        headImageVieew.sd_setImage(with: URL.init(string: vm.headImageStr), placeholderImage: UIImage.init(named: "加载图片"), options: .retryFailed, completed: nil)
    }
}
