//
//  MyActivityRespertable.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/25.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation

protocol MyActivityRespertable {
    var userId:Int {get}
    var dynamicType:Int {get}
    var contentStr:NSAttributedString {get}
    var applyStr:String {get}
    var nameStr:String {get}
    var headImageStr:String {get}
    var companyStr:String {get}
    var mesNumStr:String {get}
    var zanNumStr:String {get}
    var isLiked:Bool {get}
    var numOfZan:Int {get}
    var robRedBacketViewIsHidden:Bool {get}
    var applyViewIsHidden:Bool {get}
    var locationViewIsHidden:Bool {get}
    var heightOfLocationView:CGFloat {get}
    var addressStr:String {get}
    var currentLat:Double {get}
    var currentLon:Double {get}
    var imageNameArray:[String] {get}
    var heightOfCollection:CGFloat {get}
    var widthOfCollection:CGFloat {get}
    var zanImageStr:String {get}
}
