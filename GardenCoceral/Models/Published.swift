//
//  Published.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/25.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct Published: Mappable {
    
    var code: Double?
    var no: Double?
    var size: Double?
    var msg: String?
    var pay: Prepay?
    var orderNo: String?
    var total: Double?
    var totalPage: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code        <- map["code"]
        no          <- map["no"]
        size        <- map["size"]
        msg         <- map["msg"]
        pay         <- map["pay"]
        orderNo     <- map["orderNo"]
        total       <- map["total"]
        totalPage   <- map["totalPage"]
    }
}
struct Prepay: Mappable {
    
    var appid: String?
    var partnerid: String?
    var prepayid: String?
    var packageInfo: String?
    var noncestr: String?
    var timestamp: String?
    var sign: String?
    var signType: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        appid               <- map["appid"]
        partnerid           <- map["partnerid"]
        prepayid            <- map["prepayid"]
        packageInfo         <- map["packageInfo"]
        noncestr            <- map["noncestr"]
        timestamp           <- map["timestamp"]
        sign                <- map["sign"]
        signType            <- map["signType"]
    }
}
