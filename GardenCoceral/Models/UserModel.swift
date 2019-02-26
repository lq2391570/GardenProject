//
//  UserModel.swift
//  AptitudesQuery
//
//  Created by TongNa on 2017/6/30.
//  Copyright © 2017年 TongNa. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserModel: Mappable {
    
    var code: Double?
    var msg: String?
    var userToken: String?
    var name: String?
    var money: Double?
    var avatar: String?
    var phone: String?
    var companyName: String?
    var address: String?
    var catalog: Int?//会员状态 0为正常1没有提交入会申请2为提交了入会申请没交钱的3为已过期
    var owner: Bool?
    var job: String?
    var num: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code        <- map["code"]
        msg         <- map["msg"]
        userToken   <- map["userToken"]
        name        <- map["name"]
        money       <- map["money"]
        avatar      <- map["avatar"]
        phone       <- map["phone"]
        companyName <- map["companyName"]
        address     <- map["address"]
        catalog     <- map["catalog"]
        owner       <- map["owner"]
        job         <- map["job"]
        num         <- map["num"]
    }
}
