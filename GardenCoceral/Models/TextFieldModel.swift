//
//  RegisterModel.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/16.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation

struct TextFieldModel {
    
    var placeholder: String?
    var text: String?
    var keyboardType: UIKeyboardType?
    var isPersonal: Bool?
    
    init(_ placeholder: String, text: String, keyboardType: UIKeyboardType) {
        self.placeholder = placeholder
        self.text = text
        self.keyboardType = keyboardType
    }
}
