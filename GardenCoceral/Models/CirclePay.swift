//
//  CirclePay.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/11.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import ObjectMapper

struct CirclePay: Mappable {
    
    var logo: String?
    var name: String?
    var alias: String?
    var intro: String?
    var select: Bool?
    
    init?(map: Map) {
        
    }
    init(_ logo: String, name: String, alias: String, intro: String, select: Bool) {
        self.logo = logo
        self.name = name
        self.alias = alias
        self.intro = intro
        self.select = select
    }
    mutating func mapping(map: Map) {
        logo            <- map["logo"]
        name            <- map["name"]
        alias           <- map["alias"]
        intro           <- map["intro"]
        select          <- map["select"]
    }
}
