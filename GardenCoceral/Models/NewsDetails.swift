//
//  NewDetails.swift
//  AptitudesQuery
//
//  Created by TongNa on 2017/6/2.
//  Copyright © 2017年 TongNa. All rights reserved.
//

import Foundation
import ObjectMapper

struct NewsDetails: Mappable {
    
    var msg: String?
    var code: Double?
    var title: String?
    var note: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        msg           <- map["msg"]
        code          <- map["code"]
        title         <- map["title"]
        note          <- map["note"]
    }
}
