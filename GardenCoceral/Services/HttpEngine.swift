//
//  HttpEngine.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/8.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

//var userToken = getCurrentUser().userToken ?? ""
func userToken() ->String{
   return getCurrentUser().userToken ?? ""
}
//eyJhbGciOiJIUzUxMiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAKtWKi5NUrJSMlKqBQBuk7zJCwAAAA.RPGxEneRZjimYveUz7Gol_QN8dtRaQx_LotSBSUCxWUk7FadPiWQQSaoK-e66yyORad-D02F7LfwlIrY-f5bQg

//let USERID = getCurrentUser()
let MyLocation = "https://api.shanxigl.cn/rest/"
//获取联系人URL
let AddressBookListURL = "leaguer/list.htm"
//获取商圈动态URL
let ActivityAndMoodListUrl = "feed/page.htm"
//点赞URL
let zanUrl = "feed/like.htm"
//获取头条文章
let hotArticleUrl = "article/page.htm"
//获取某条动态详情
let dynamicDetailUrl = "feed/findById.htm"
//获取某条心情的点赞数据
let likesUrl = "feed/likes.htm"
//获取某条心情的评论列表
let commentListUrl = "feed/comments.htm"
//给某条心情评论
let commentOfDynamicUrl = "feed/comment.htm"
//获取某个用户的动态
let dynamicForUserUrl = "feed/user.htm"
//获取我的动态
let myDynamicUrl = "feed/my.htm"
//活动报名
let activityApplyUrl = "activity/attend.htm"
//获取某条的心情的报名数据
let activityApplyListUrl = "feed/joins.htm"
//获取某条的心情打开的红包列表
let hotBacketListUrl = "feed/opens.htm"
//获取广告列表
let getADListUrl = "ad/list.htm"
//我发布的活动
let myPublishUrl = "center/mypubactivity.htm"
//我参与的活动
let myJoinUrl = "center/myjoinactivity.htm"
//获取头条详情
let articleDetailUrl = "article/findbyid.htm"
//给文章点赞
let zanForArticleUrl = "article/liked.htm"
//每日最大红包
let biggestHotBacketUrl = "redpacket/max.htm"
//拆红包
let pullDownHotBacketUrl = "redpacket/open.htm"
//会员风采
let memberElegantUrl = "vipstyle/page.htm"
//客户端显示了最大红包
let biggestHotPacketShowedUrl = "redpacket/showday.htm"
//首页红包列表
let firstVCHotBacketListUrl = "redpacket/page.htm"
//合作项目列表
let projectListUrl = "project/page.htm"
//合作项目详情
let projectDetailUrl = "project/id.htm"
//项目报名
let projectJoinUrl = "project/join.htm"





//获取联系人model
var AddressBookModel:AddressBookAddressBookBaseClass!
//获取商圈动态model
var ActivityAndMoodModel:ActivityActivityBassClass!
//头条文章model
var HotArticleModel:HotArticleHotArticleBassClass!
//动态详情model
var dynamicDetailModel:DynamicDetailDynamicDetailBassClass!
//某条心情的点赞列表model
var likesModel:LikesLikesBassClass!
//某条心情的评论列表model
var commentListModel:CommentListCommentListBaseClass!
//广告
var adListModel:ADListADList!
//我发布的活动
var myPublishModel:MyPublishMyPublishbassClass!
//合作项目model
var projectListModel:ProjectProjectBaseClass!


func startRequest(requestURLStr:String,dic:NSDictionary,actionHandler:@escaping (_ jsonModel:JSON) -> Void , fail : () -> Void)->Void
{
    Alamofire.request("\(MyLocation)\(requestURLStr)", method: .post, parameters: dic as? Parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
        print("result==\(response.result.value ?? "nonResponse")")
        switch response.result.isSuccess{
        case true:
            guard let value = response.result.value else {
                return
            }
            let jsonStr=JSON(value)
            actionHandler(jsonStr)
        case false:
            print("\(response.result.error ?? "nonError" as! Error)")
        }
        
    }
}
