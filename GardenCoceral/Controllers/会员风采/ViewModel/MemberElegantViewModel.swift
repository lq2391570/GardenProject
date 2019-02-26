//
//  MemberElegantViewModel.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/24.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation

struct MemberElegantViewModel {
    var listModel:MemberElegantList!
    var headImageStr:String {
        return listModel.logo ?? ""
    }
    var nameStr:String {
        return listModel.name ?? ""
    }
    var phoneNumStr:String {
        return listModel.phone ?? ""
    }
    var addressStr:String {
        return listModel.address ?? ""
    }
}
extension MemberElegantViewModel:MemberElegantRestable {}
