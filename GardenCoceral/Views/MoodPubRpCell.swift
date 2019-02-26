//
//  MoodPubRpCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/2.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class MoodPubRpCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var num: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.cornerRadius = 5
        contentView.borderColor = UIColor(hexString: "#ededed")
        contentView.borderWidth = 1
    }

}
