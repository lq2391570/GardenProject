//
//  AlipayCallback.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/25.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct AlipayCallback: Mappable {
    
    var response: AlipayResponse?
    var sign: String?
    var sign_type: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        response             <- map["alipay_trade_app_pay_response"]
        sign                 <- map["sign"]
        sign_type            <- map["sign_type"]
    }
}
struct AlipayResponse: Mappable {
    
    var code: String?
    var msg: String?
    var app_id: String?
    var auth_app_id: String?
    var timestamp: String?
    var total_amount: String?
    var trade_no: String?
    var seller_id: String?
    var out_trade_no: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code            <- map["code"]
        msg             <- map["msg"]
        app_id          <- map["app_id"]
        auth_app_id     <- map["auth_app_id"]
        timestamp       <- map["timestamp"]
        total_amount    <- map["total_amount"]
        trade_no        <- map["trade_no"]
        seller_id       <- map["seller_id"]
        out_trade_no    <- map["out_trade_no"]
        
    }
}
