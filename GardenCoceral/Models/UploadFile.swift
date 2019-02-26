//
//  UploadFile.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/17.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct UploadFile: Mappable {
    
    var code: Double?
    var msg: String?
    var url: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code        <- map["code"]
        msg         <- map["msg"]
        url         <- map["url"]
    }
}
