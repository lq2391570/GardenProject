//
//  WithdrawResponse.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/5/3.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct WithdrawResponse: Mappable {
    
    var code: Double?
    var msg: String?
    var money: Double?
    var fee: Double?
    var minCash: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code        <- map["code"]
        msg         <- map["msg"]
        money       <- map["money"]
        fee         <- map["fee"]
        minCash     <- map["minCash"]
    }
}
