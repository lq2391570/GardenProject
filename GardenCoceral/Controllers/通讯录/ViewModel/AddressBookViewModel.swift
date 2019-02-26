//
//  AddressBookViewModel.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/24.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation

struct AddressBookViewModel {
    var listModel:AddressBookList!
    
    var name:String {
        return listModel.name ?? ""
    }
    var position:String {
        return listModel.job ?? ""
    }
    var headImageStr:String {
        return listModel.avatar ?? ""
    }
    
}
extension AddressBookViewModel:AddressBookRestable {}
