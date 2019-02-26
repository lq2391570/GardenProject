//
//  WithdrawRecordsResponse.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/19.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct CashRecordsResponse: Mappable {
    
    var code: Double?
    var no: Double?
    var size: Double?
    var msg: String?
    var list: [CashRecord]?
    var total: Double?
    var totalPage: Double?
    var minCash: Double?
    var money: Double?
    var fee: Double?
    
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
        minCash     <- map["minCash"]
        money       <- map["money"]
        fee         <- map["fee"]
    }
}
struct CashRecord: Mappable {
    
    var money: Double?
    var title: String?
    var id: Int?
    var note: String?
    var date: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        money         <- map["money"]
        title         <- map["title"]
        id            <- map["id"]
        note          <- map["note"]
        date          <- map["date"]
    }
}
