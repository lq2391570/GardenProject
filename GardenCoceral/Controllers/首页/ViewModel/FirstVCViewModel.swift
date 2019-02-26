//
//  FirstVCViewModel.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/26.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation

struct FirstVCViewModel {
    var listModel:ActivityList!
    var userId:Int {
        return listModel.member?.id ?? 0
    }
    var catalog:Int {
        return listModel.catalog ?? 0
    }
    var robRedBacketViewIsHidden:Bool {
        return catalog == 0 ? true:listModel.haveRedPacket == 0 || listModel.haveRedPacket == nil ? true:false
    }
    var applyViewIsHidden:Bool {
        return catalog == 0 ? false:true
    }
    var contentStr:NSAttributedString {
        
        let str = "\(listModel.activity?.note ?? "什么话都没有说")\n活动时间：\(listModel.activity?.date ?? "暂无")\n活动地点：\(listModel.activity?.address ?? "暂无")"
        //调整行间距
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 10.0
        let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15),NSAttributedStringKey.paragraphStyle:paraph]
        return NSAttributedString(string: str,attributes:attributes)
        
    }
    var contentStrWithMood:String{
        return listModel.note ?? "无"
    }
    var applyStr:String {
        return "\(listModel.activity?.joinNum ?? 0)/\(listModel.activity?.num ?? 0)"
    }
    var locationViewIsHidden:Bool {
        if catalog == 0 {
            return false
        }else{
            if listModel.address == nil || listModel.address == "" {
                return true
            }else{
                return false
            }
        }
    }
    var heightOfLocationView:CGFloat {
        if catalog == 0 {
            return 27
        }else{
            if listModel.address == nil || listModel.address == "" {
                return 0
            }else{
                return 27
            }
        }
    }
    var addressStr:String {
        return listModel.activity?.address ?? ""
    }
    var currentLat:Double{
        return listModel.activity?.lat?.double ?? 0
    }
    var currentLon:Double {
        return listModel.activity?.lng?.double ?? 0
    }
    var currentAddressStr:String {
        return listModel.address ?? ""
    }
    var numOfZan:Int {
        return listModel.likes ?? 0
    }
    var nameStr:String {
        return listModel.member?.name ?? ""
    }
    var listmodelHeadImageStr:String {
        return listModel.member?.avatar ?? ""
    }
    var listModelCompanyStr:String {
        return listModel.member?.companyName ?? ""
    }
    var listModelMesNumStr:String {
        return "\(listModel.comments ?? 0)"
    }
    var listModelZanNumStr:String {
        return "\(numOfZan)"
    }
    var zanImageViewStr:String {
        if listModel.liked == true {
            return "点赞（已点）"
        }else{
            return "点赞（未点）"
        }
    }
    var imageNameArray:[String] {
        var imageStrArray:[String] = []
        if listModel.images?.count != 0 {
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
   

}
extension FirstVCViewModel:FirstVCRespertable {}
