//
//  ProjectDetailViewModel.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/23.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation

struct projectDetailViewModel {
    var projectDetailBassClass:ProjectDetailProjectDetailBaseClass!
    
    var headImageStr:String {
        return projectDetailBassClass.logo ?? ""
    }
    var titleName:String {
        return projectDetailBassClass.name ?? ""
    }
    var numOfPeople:Int {
        return projectDetailBassClass.num ?? 0
    }
    var contentNote:String {
        return projectDetailBassClass.note ?? ""
    }
    var dateStr:String {
        return projectDetailBassClass.date ?? ""
    }

}
extension projectDetailViewModel:ProjectDetailRespertable {}
extension projectDetailViewModel:ProjectImageRespertable {}


