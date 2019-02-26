//
//  TokenModel.swift
//  AptitudesQuery
//
//  Created by TongNa on 2017/5/27.
//  Copyright © 2017年 TongNa. All rights reserved.
//

import Foundation
import ObjectMapper

struct TokenModel: Mappable {
    
    var code: Double?
    var message: String?
    var token: String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code         <- map["code"]
        message      <- map["message"]
        token        <- map["token"]
    }
}
