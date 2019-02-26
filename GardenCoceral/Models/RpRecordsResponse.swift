//
//  RpRecordsResponse.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/18.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct RpRecordsResponse: Mappable {
    
    var code: Double?
    var no: Double?
    var size: Double?
    var msg: String?
    var list: [RpRecord]?
    var total: Double?
    var totalPage: Double?
    var money: Double?

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
        money       <- map["money"]
    }
    
}
struct RpRecord: Mappable {
    
    var date: String?
    var addDate: Double?
    var id: Int?
    var money: Double?
    var num: Int?
    var openNum: Int?
    var datas: [RpRecordDetail]?
    var expand: Bool?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        date           <- map["date"]
        addDate        <- map["addDate"]
        id             <- map["id"]
        money          <- map["money"]
        num            <- map["num"]
        openNum        <- map["openNum"]
        datas          <- map["datas"]
        expand         <- map["expand"]
    }
}
struct RpRecordDetail: Mappable {
    
    var date: Double?
    var money: Double?
    var name: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        date           <- map["date"]
        money          <- map["money"]
        name           <- map["name"]
    }
}
