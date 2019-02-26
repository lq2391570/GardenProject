//
//  WebBottomView.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/25.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class WebBottomView: UIView {

    var zanBtnClickClosure:((UIButton) ->())?
    
    
    @IBAction func zanBtnClick(_ sender: UIButton) {
        if zanBtnClickClosure != nil {
            zanBtnClickClosure!(sender)
        }
    }
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
    static func newInstance() -> WebBottomView{
        let view = Bundle.main.loadNibNamed("WebBottomView", owner: self, options: nil)?.last as! WebBottomView
        return view
    }
}
