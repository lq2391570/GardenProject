//
//  ADModel.swift
//  AptitudesQuery
//
//  Created by TongNa on 2017/6/8.
//  Copyright © 2017年 TongNa. All rights reserved.
//

import Foundation
import ObjectMapper

struct ADModel: Mappable {
    
    var code: Double?
    var size: Double?
    var msg: String?
    var list: [AD]?
    var total: Double?
    var totalPage: Double?
    var page: Double?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code        <- map["code"]
        size        <- map["size"]
        msg         <- map["msg"]
        list        <- map["list"]
        total       <- map["total"]
        totalPage   <- map["totalPage"]
        size        <- map["size"]
        page        <- map["page"]
    }
}
struct AD: Mappable {
    
    var title: String?
    var id: Int?
    var content: String?
    var path: String?
    var url: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        title           <- map["title"]
        id              <- map["id"]
        content         <- map["content"]
        path            <- map["path"]
        url             <- map["url"]
    }
}
