//
//  MemberRecord.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct MemberRecordResponse: Mappable {
    
    var code: Double?
    var no: Double?
    var size: Double?
    var msg: String?
    var list: [MemberRecord]?
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

struct MemberRecord: Mappable {
    
    var name: String?
    var state: String?
    var job: String?
    var date: String?
    
    init?(map: Map) {
        
    }
    init(_ name: String, state: String, job: String, date: String) {
        self.name = name
        self.state = state
        self.job = job
        self.date = date
    }
    mutating func mapping(map: Map) {
        name          <- map["name"]
        state         <- map["state"]
        job           <- map["job"]
        date          <- map["date"]
    }
}
