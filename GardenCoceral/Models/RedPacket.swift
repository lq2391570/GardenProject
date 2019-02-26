//
//  RedPacket.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/2.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct RedPacketResponse: Mappable {
    
    var code: Double?
    var msg: String?
    var list: [RedPacket]?
    
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        code         <- map["code"]
        msg          <- map["msg"]
        list         <- map["list"]
    }
}

struct RedPacket: Mappable {
    
    var num: Int?
    var money: Int?
    var selected: Bool?
    
    init?(map: Map) {
        
    }
    init(_ num: Int, money: Int, selected: Bool) {
        self.num = num
        self.money = money
        self.selected = selected
    }
    mutating func mapping(map: Map) {
        num           <- map["num"]
        money         <- map["money"]
        selected      <- map["selected"]
    }
}
