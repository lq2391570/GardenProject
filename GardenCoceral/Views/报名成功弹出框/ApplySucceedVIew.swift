//
//  ApplySucceedVIew.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/16.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class ApplySucceedVIew: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    static func newInstance() -> ApplySucceedVIew{
        let view = Bundle.main.loadNibNamed("ApplySucceedView", owner: self, options: nil)?.last as! ApplySucceedVIew
        return view
    }

}
