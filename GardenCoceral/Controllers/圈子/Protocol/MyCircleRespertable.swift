//
//  MyCircleRespertable.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/25.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation

protocol MyCircleRespertable {
    var memModel:ActivityMember {get}
    var headImageStr:String {get}
    var nameAndPositionStr:NSAttributedString {get}
    var companyStr:String {get}
    var phoneNumStr:String {get}
}

protocol MyCircleRespertable2 {
    var userId:Int {get}
    var catalog:Int {get}
    var robRedBacketViewIsHidden:Bool {get}
    var applyViewIsHidden:Bool {get}
    var contentStr:NSAttributedString {get}
    var contentStrWithMood:String {get}
    var applyStr:String {get}
    var locationViewIsHidden:Bool {get}
    var heightOfLocationView:CGFloat {get}
    var addressStr:String {get}
    var currentLat:Double {get}
    var currentLon:Double {get}
    var currentAddressStr:String {get}
    var numOfZan:Int {get}
    var nameStr:String {get}
    var listmodelHeadImageStr:String {get}
    var listModelCompanyStr:String {get}
    var listModelMesNumStr:String {get}
    var listModelZanNumStr:String {get}
    var zanImageViewStr:String {get}
    var imageNameArray:[String] {get}
    var heightOfCollection:CGFloat {get}
    var widthOfCollection:CGFloat {get}
    var dataLabelIsHidden:Bool {get}
    var topViewHeight:CGFloat {get}
    var topOfContentLabel:CGFloat {get}
    var topViewIsHidden:Bool {get}
    var dateStr:String {get}
    var shareBtnIsHidden:Bool {get}
    var shareImageViewIsHidden:Bool {get}

    
    
}
