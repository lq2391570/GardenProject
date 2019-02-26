//
//  Circle.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/3/28.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct Circle: Mappable {
    
    var date: Double?
    var content: String?
    var imgs: [String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        date         <- map["date"]
        content      <- map["content"]
        imgs         <- map["imgs"]
    }
}
