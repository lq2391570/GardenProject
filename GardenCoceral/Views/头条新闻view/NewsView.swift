//
//  NewsView.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/3/26.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class NewsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    */
    @IBOutlet var label1: UILabel!
    
    @IBOutlet var label2: UILabel!
    
//    var lable1ClickClosure:(() -> ())?
//    var label2ClickClosure:(() -> ())?
    
    override func draw(_ rect: CGRect) {
        // Drawing code

       
    }

    @IBAction func label1Click(_ sender: UIButton) {
        print("点击了label1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    static func newInstance() -> NewsView{
        let view = Bundle.main.loadNibNamed("NewsView", owner: self, options: nil)?.last as! NewsView
        
        return view
    }
    

}
