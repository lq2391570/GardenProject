//
//  SearchView.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/8.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class SearchView: UIView,UITextFieldDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        searchTextField.delegate = self
    }
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var searchBtn: UIButton!
    
    var searchBtnClickClosure:((UIButton) -> ())?
    
    var returnkeyClickClosure:((UITextField) -> ())?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    static func newInstance() -> SearchView{
        let view = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)? .last as! SearchView
        return view
    }
    @IBAction func searchBtnClick(_ sender: UIButton) {
        if searchBtnClickClosure != nil {
            searchBtnClickClosure!(sender)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if returnkeyClickClosure != nil {
            returnkeyClickClosure!(textField)
        }
        print("returnKeyClick")
        return true
    }
}
