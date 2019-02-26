//
//  PartnerViewModel.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/23.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation

struct PartnerViewModel {
    
    var projectListModel:ProjectList
    
    
    var headImageStr:String {
        return projectListModel.logo ?? ""
    }
    var titleStr:String {
        return projectListModel.name ?? ""
    }
    var descStr:String {
        return projectListModel.desc ?? ""
    }
    var dateStr:String {
        return projectListModel.date ?? ""
    }
    
    
    
    
}
extension PartnerViewModel:PartnerRepresentable {}
