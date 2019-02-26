//
//  MyCollectionView.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/3/28.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class MyCollectionView: UICollectionView {

    @IBOutlet var containView: UIView!
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
    static func newInstance() -> MyCollectionView{
        let view = Bundle.main.loadNibNamed("MyCollectionView", owner: self, options: nil)? .last as! MyCollectionView
        return view
    }
    
}
