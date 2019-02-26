//
//  DynamicCommentCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/12.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class DynamicCommentCell: UITableViewCell {

    enum CommentCellType {
        case commentType //评论
        case hotBacket //红包
    }
    @IBOutlet var headImageBtn: UIButton!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var contentLabel: UILabel!
    
    @IBOutlet var numOfMoneyLabel: UILabel!
    
    @IBOutlet var trailingOfRight: NSLayoutConstraint!
    
    var cellType:CommentCellType  = .commentType
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        numOfMoneyLabel.isHidden = true
        trailingOfRight.constant = self.cellType == .hotBacket ? 56:16
        self.selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    func confingerCell(with vm:DynamicDetailCommentRespertable) -> Void {
        headImageBtn.sd_setBackgroundImage(with: URL.init(string: vm.headImageStr), for: UIControlState.normal, placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: nil)
        nameLabel.text = vm.nameLabel
        contentLabel.text = vm.contentStr
        numOfMoneyLabel.isHidden = vm.numOfMoneyLabelIsHidden
        numOfMoneyLabel.text = vm.numOfMoneyStr
    }
    
    
}
