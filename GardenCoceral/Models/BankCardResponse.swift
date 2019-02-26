//
//  BankCardResponse.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/19.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct BankCardResponse: Mappable {
    
    var code: Double?
    var no: Double?
    var size: Double?
    var msg: String?
    var list: [BankCard]?
    var total: Double?
    var totalPage: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code        <- map["code"]
        no          <- map["no"]
        size        <- map["size"]
        msg         <- map["msg"]
        list        <- map["list"]
        total       <- map["total"]
        totalPage   <- map["totalPage"]
    }
    
}
struct BankCard: Mappable {
    
    var bankName: String?
    var bankNo: String?
    var id: Int?
    var name: String?
    var initBank: String?
    var icon: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        bankName      <- map["bankName"]
        bankNo        <- map["bankNo"]
        id            <- map["id"]
        name          <- map["name"]
        initBank      <- map["initBank"]
        icon          <- map["icon"]
    }
}
