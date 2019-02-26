//
//  BigHotBacketView.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/16.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class BigHotBacketView: UIView {

    @IBOutlet var pullDownBtn: UIButton!
    
    @IBOutlet var nameLabell: UILabel!
    //拆点击closure
    var pullDownClickClosure:((UIButton) -> ())?
    
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
    static func newInstance() -> BigHotBacketView{
        let view = Bundle.main.loadNibNamed("BigHotBacketView", owner: self, options: nil)?.last as! BigHotBacketView
        return view
    }
    @IBAction func pullDownBtnClick(_ sender: UIButton) {
        if self.pullDownClickClosure != nil {
            self.pullDownClickClosure!(sender)
        }
    }
    
}
