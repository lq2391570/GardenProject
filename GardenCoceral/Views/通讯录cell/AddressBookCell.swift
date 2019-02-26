//
//  AddressBookCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/3/29.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class AddressBookCell: UITableViewCell {

    @IBOutlet var headImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var positionLabel: UILabel!
    
    @IBOutlet var phoneBtn: UIButton!
    
    var phoneBtnClickClosure:((UIButton) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    @IBAction func phoneBtnClick(_ sender: UIButton) {
        if phoneBtnClickClosure != nil {
            phoneBtnClickClosure!(sender)
        }
        
    }
    func confingerCell(with vm:AddressBookRestable) -> Void {
        headImageView.sd_setImage(with: URL.init(string: vm.headImageStr), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: nil)
        nameLabel.text = vm.name
        positionLabel.text = vm.position
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
