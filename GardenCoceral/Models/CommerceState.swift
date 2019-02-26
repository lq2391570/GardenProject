//
//  CommerceState.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/5/28.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct CommerceState: Mappable {
    
    var state: String?
    var beginDate: String?
    var endDate: String?
    var rules: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        state        <- map["state"]
        beginDate         <- map["beginDate"]
        endDate       <- map["endDate"]
        rules         <- map["rules"]
    }
}
