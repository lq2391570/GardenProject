//
//  MoodPubImgCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/2.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class MoodPubImgCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var img: UIImageView!
    var deletePhoto: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func deletePhoto(_ sender: UIButton) {
        if let delete = deletePhoto {
            delete()
        }
    }
    
}
