//
//  MyActivityViewModel.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/25.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation

struct MyActivityViewModel {
    var listModel:MyPublishList!
    
    var userId:Int {
        return listModel.member?.id ?? 0
    }
    var dynamicType:Int {
        return 0
    }
   
    var contentStr:NSAttributedString {
        let str = "\(listModel.note ?? "什么话都没有说")\n活动时间：\(listModel.date ?? "暂无")\n活动地点：\(listModel.address ?? "暂无")"
        //调整行间距
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 10.0
        let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.paragraphStyle:paraph]
        return NSAttributedString(string: str,attributes:attributes)
    }
    var applyStr:String {
        return "\(listModel.joinNum ?? 0)/\(listModel.num ?? 0)"
    }
    var nameStr:String {
        return listModel.member?.name ?? ""
    }
    var headImageStr:String {
        return listModel.member?.avatar ?? ""
    }
    var companyStr:String {
        return listModel.member?.companyName ?? ""
    }
    var mesNumStr:String {
        return "\(listModel.comments ?? 0)"
    }
    var zanNumStr:String {
        return "\(listModel.likes ?? 0)"
    }
    var isLiked:Bool {
        return listModel.liked ?? false
    }
    var numOfZan:Int {
        return listModel.likes ?? 0
    }
    var robRedBacketViewIsHidden:Bool {
        return true
    }
    var applyViewIsHidden:Bool {
        return false
    }
    var locationViewIsHidden:Bool {
        return false
    }
    var heightOfLocationView:CGFloat {
        return 27
    }
    var addressStr:String {
        return listModel.address ?? ""
    }
    var currentLat:Double {
        return listModel.lat?.double ?? 0
    }
    var currentLon:Double {
        return listModel.lng?.double ?? 0
    }
    
    var imageNameArray:[String] {
         var imageStrArray:[String] = []
        if listModel.images?.count != 0 && listModel.images != nil {
            listModel.images?.forEach { imageStrArray.append($0.url!) }
        }
        return imageStrArray
    }
    var heightOfCollection:CGFloat {
        if imageNameArray.count == 1 {
            return 160
        }else if imageNameArray.count == 0 {
            return 0
        }else{
            return (CGFloat)(imageNameArray.count / 4 + 1) * 90.0
        }
    }
    var widthOfCollection:CGFloat {
        if imageNameArray.count == 1 {
            return 160
        }else if imageNameArray.count == 0 {
            return 0
        }else{
            return 240
        }
    }
    
    var zanImageStr:String {
        if isLiked == true {
            return "点赞（已点）"
        }else{
            return "点赞（未点）"
        }
        
    }
    
    
    
    
}
extension MyActivityViewModel:MyActivityRespertable {}

