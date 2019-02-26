//
//  Service.swift
//
//  Created by TongNa on 2017/5/10.
//  Copyright © 2017年 TongNa. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Result
import SVProgressHUD

let IMAGEURL = "https://img.shanxigl.cn/upload/"
let appKey = "tongnaios"
let appSecret = "j0p9w6h533512k10p3jjj718ep8"

enum MyAPI {
    case findToken()//获取程序的token
    case refreshToken(String)//更新程序的token
    case getHomepageNews(String, no: Int, size: Int)
    case getNewsList(String, no: Int, size: Int)
    case getNewsDetails(String, id: Int, system: String)
    case getAD(String, type: Int, size: Int)
    case sendCode(String, phone: String, catalog: String)//catalog 类型(register,login,binding,reset,changePhone)
    case register(String, phone: String, code: String, password: String)
    case loginWithPassword(String, phone: String, password: String)
    case loginOAuth(String, code: String, type: String)//type 第三方类型（weixin，qq，iosqq）
    case registerOAuth(String, type: String, openId: String, accessToken: String, phone: String, code: String)
    case loginByCode(String, phone: String, code: String)
    case updateUserInfo(String, userToken: String, name: String, avatar: String)
    case modifyPhone(String, userToken: String, phone: String, code: String)
    case modifyPassword(String, userToken: String, oldPassword: String, password: String)
    case resetPassword(String, phone: String, code: String, password: String)
    case uploadFile(String)
    case publishMood(String, userToken: String, note: String, address: String, lng: Double, lat: Double, money: Double, num: Int, imgs: [String], payType: String)
    case publishActivity(String, userToken: String, note: String, address: String, lng: Double, lat: Double, money: Double, num: Int, beginDate: Double, imgs: [String])
    case getPublishedRedPackets(String, userToken: String, no: Int, size: Int)
    case getOpenedRedPackets(String, userToken: String, no: Int, size: Int)
    case getUserBankCards(String, userToken: String, no: Int, size: Int)
    case addBankCard(String, userToken: String, bankName: String, bankNo: String, name: String, initBank: String)
    case getCashRecords(String, userToken: String, no: Int, size: Int)
    case commerceApply(String, userToken: String, applyType: String, name: String, companyName: String, companyAddress: String, phone: String, job: String, logo: String, no: String, image: String, legalPerson: String)
    case addCommerceMemberApply(String, userToken: String, applyType: String, name: String, companyName: String, companyAddress: String, phone: String, job: String, no: String, image: String, legalPerson: String)
    case updateAvatar(String, userToken: String, avatar: String)
    case changePassword(String, userToken: String, oldPassword: String, password: String)
    case commerceApplyRecord(String, userToken: String, no: Int, size: Int)
    case getRedPacketConfig(String, userToken: String)
    case getEnrollConfig(String, userToken: String)
    case attendActivity(String, userToken: String, id: Int, money: Double, payType: String)
    case attendProject(String, userToken: String, id: Int, money: Double, payType: String)
    case withdraw(String, userToken: String, bankId: Int, money: Double)
    case getUserInfo(String, userToken: String)
    case getUserCommerceState(String, userToken: String)
}

extension MyAPI: TargetType {
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        switch self {
        case .uploadFile(_):
            return URL(string:"https://api.shanxigl.cn/file/upload.htm")!
        default:
            return URL(string:"https://api.shanxigl.cn/rest/")!
        }
    }
    
    var path: String {
        switch self {
        case .findToken():
            return "app/findToken.htm"
        case .refreshToken(_):
            return "app/refreshToken.htm"
        case .getHomepageNews(_,_,_):
            return "article/list.htm"
        case .getNewsList(_,_,_):
            return "article/page.htm"
        case .getNewsDetails(_,_,_):
            return "article/id.htm"
        case .getAD(_,_,_):
            return "ad/adlist.htm"
        case .sendCode(_, _, _):
            return "user/sendcode.htm"
        case .register(_, _, _, _):
            return "user/registerByCode.htm"
        case .loginWithPassword(_, _, _):
            return "member/login.htm"
        case .loginOAuth(_, _, _):
            return "member/loginoauth.htm"
        case .registerOAuth(_, _, _, _, _, _):
            return "user/registerOauth.htm"
        case .loginByCode(_,_,_):
            return "user/loginByCode.htm"
        case .updateUserInfo(_, _, _, _):
            return "user/update.htm"
        case .modifyPhone(_, _, _, _):
            return "user/changePhone.htm"
        case .modifyPassword(_, _, _, _):
            return "user/changePassword.htm"
        case .resetPassword(_, _, _, _):
            return "user/resetpassword.htm"
        case .uploadFile(_):
            return ""
        case .publishMood(_, _, _, _, _, _, _, _, _, _):
            return "feed/pubfeedjson.htm"
        case .publishActivity(_, _, _, _, _, _, _, _, _, _):
            return "feed/pubactivityjson.htm"
        case .getPublishedRedPackets(_, _, _, _):
            return "center/mypub.htm"
        case .getOpenedRedPackets(_, _, _, _):
            return "center/myopen.htm"
        case .getUserBankCards(_, _, _, _):
            return "bankcard/page.htm"
        case .addBankCard(_, _, _, _, _, _):
            return "bankcard/bind.htm"
        case .getCashRecords(_, _, _, _):
            return "cash/page.htm"
        case .commerceApply(_, _, _, _, _, _, _, _, _, _, _, _):
            return "commerceapply/apply.htm"
        case .addCommerceMemberApply(_, _, _, _, _, _, _, _, _, _, _):
            return "commerceapply/addmy.htm"
        case .updateAvatar(_, _, _):
            return "member/updateavatar.htm"
        case .changePassword(_, _, _, _):
            return "user/changePassword.htm"
        case .commerceApplyRecord(_, _, _, _):
            return "commerceapply/page.htm"
        case .getRedPacketConfig(_, _):
            return "redpacket/list.htm"
        case .getEnrollConfig(_, _):
            return "activity/config.htm"
        case .attendActivity(_, _, _, _, _):
            return "activity/attend.htm"
        case .attendProject(_, _, _, _, _):
            return "project/join.htm"
        case .withdraw(_, _, _, _):
            return "cash/addcash.htm"
        case .getUserInfo(_, _):
            return "member/my.htm"
        case .getUserCommerceState(_, _):
            return "commerceapply/state.htm"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .sendCode(let commerce, let phone, let catalog):
            return .requestParameters(parameters: ["commerce":commerce, "phone":phone, "catalog":catalog], encoding: URLEncoding.default)
        case .loginWithPassword(let commerce, let phone, let password):
            return .requestParameters(parameters: ["commerce":commerce, "phone":phone, "password":password], encoding: URLEncoding.default)
        case .loginOAuth(let commerce, let code, let type):
            return .requestParameters(parameters: ["commerce":commerce, "code":code, "type":type], encoding: URLEncoding.default)
        case .uploadFile(let imageData):
            let img = MultipartFormData(provider: .file(URL(fileURLWithPath: imageData)), name: "file", fileName: "tongna.jpg", mimeType: "image/jpeg")
            return .uploadMultipart([img])
        case .publishMood(let commerce, let userToken, let note, let address, let lng, let lat, let money, let num, let imgs, let payType):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "note":note, "address":address, "lat":lng, "lng":lat, "money":money, "num":num, "images":imgs, "payType":payType], encoding: JSONEncoding.default)
        case .publishActivity(let commerce, let userToken, let note, let address, let lng, let lat, let money, let num, let beginDate, let imgs):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "note":note, "address":address, "lng":lng, "lat":lat, "money":money, "num":num, "beginDate":beginDate, "images":imgs], encoding: JSONEncoding.default)
        case .getPublishedRedPackets(let commerce, let userToken, let no, let size):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "no":no, "size": size], encoding: URLEncoding.default)
        case .getOpenedRedPackets(let commerce, let userToken, let no, let size):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "no":no, "size": size], encoding: URLEncoding.default)
        case .getUserBankCards(let commerce, let userToken, let no, let size):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "no":no, "size": size], encoding: URLEncoding.default)
        case .addBankCard(let commerce, let userToken, let bankName, let bankNo, let name, let initBank):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "bankName":bankName, "bankNo": bankNo, "name": name, "initBank": initBank], encoding: URLEncoding.default)
        case .getCashRecords(let commerce, let userToken, let no, let size):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "no":no, "size": size], encoding: URLEncoding.default)
        case .commerceApply(let commerce, let userToken, let applyType, let name, let companyName, let companyAddress, let phone, let job, let logo, let no, let image, let legalPerson):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "applyType":applyType, "name": name, "companyName":companyName, "companyAddress":companyAddress, "phone": phone, "job":job, "logo":logo, "no":no, "image": image, "legalPerson":legalPerson], encoding: URLEncoding.default)
        case .addCommerceMemberApply(let commerce, let userToken, let applyType, let name, let companyName, let companyAddress, let phone, let job, let no, let image, let legalPerson):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "applyType":applyType, "name": name, "companyName":companyName, "companyAddress":companyAddress, "phone": phone, "job":job, "no":no, "image": image, "legalPerson":legalPerson], encoding: URLEncoding.default)
        case .updateAvatar(let commerce, let userToken, let avatar):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "avatar":avatar], encoding: URLEncoding.default)
        case .changePassword(let commerce, let userToken, let oldPassword, let password):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "oldPassword":oldPassword, "password": password], encoding: URLEncoding.default)
        case .resetPassword(let commerce, let phone, let code, let password):
            return .requestParameters(parameters: ["commerce":commerce, "phone":phone, "code":code, "password": password], encoding: URLEncoding.default)
        case .commerceApplyRecord(let commerce, let userToken, let no, let size):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "no":no, "size": size], encoding: URLEncoding.default)
        case .getRedPacketConfig(let commerce, let userToken):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken], encoding: URLEncoding.default)
        case .getEnrollConfig(let commerce, let userToken):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken], encoding: URLEncoding.default)
        case .attendActivity(let commerce, let userToken, let id, let money, let payType):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "id":id, "money":money, "payType":payType], encoding: URLEncoding.default)
        case .attendProject(let commerce, let userToken, let id, let money, let payType):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "id":id, "money":money, "payType":payType], encoding: URLEncoding.default)
        case .withdraw(let commerce, let userToken, let bankId, let money):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken, "bankId":bankId, "money":money], encoding: URLEncoding.default)
        case .getUserInfo(let commerce, let userToken):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken], encoding: URLEncoding.default)
        case .getUserCommerceState(let commerce, let userToken):
            return .requestParameters(parameters: ["commerce":commerce, "userToken":userToken], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
}

class MyService {
    
    static let shareInstance = MyService()
    private init() {}
    
    static let networkActivityPlugin = NetworkActivityPlugin(networkActivityClosure: {(change: NetworkActivityChangeType, MyAPI) in
        switch change {
        case .began:
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        case .ended:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    })
    static let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<MyAPI>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 10
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    }
    private let provider = MoyaProvider<MyAPI>(requestClosure: requestTimeoutClosure, plugins: [networkActivityPlugin])
    
    func findToken() -> Single<TokenModel> {
        return provider.rx.request(.findToken())
        .filterSuccessfulStatusCodes()
        .mapObject(TokenModel.self)
    }
    func refreshToken(_ token: String) -> Single<TokenModel> {
        return provider.rx.request(.refreshToken(token))
            .filterSuccessfulStatusCodes()
            .mapObject(TokenModel.self)
    }
    func getHomepageNews(_ token: String, no :Int, size: Int) -> Single<NewsList> {
        return provider.rx.request(.getHomepageNews(token, no: no, size: size))
            .filterSuccessfulStatusCodes()
            .mapObject(NewsList.self)
    }
    func getNewsList(_ token: String, no :Int, size: Int) -> Single<NewsList> {
        return provider.rx.request(.getNewsList(token, no: no, size: size))
            .filterSuccessfulStatusCodes()
            .mapObject(NewsList.self)
    }
    func getNewsDetails(_ token: String, id :Int, system: String) -> Single<NewsDetails> {
        return provider.rx.request(.getNewsDetails(token, id: id, system: system))
            .filterSuccessfulStatusCodes()
            .mapObject(NewsDetails.self)
    }
    func getAD(_ token: String, type :Int, size: Int) -> Single<ADModel> {
        return provider.rx.request(.getAD(token, type: type, size: size))
            .filterSuccessfulStatusCodes()
            .mapObject(ADModel.self)
    }
    func sendCode(_ commerce: String, phone: String, catalog: String) -> Single<UserModel> {
        return provider.rx.request(.sendCode(commerce, phone: phone, catalog: catalog))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func register(_ token: String, phone: String, code: String, password: String) -> Single<UserModel> {
        return provider.rx.request(.register(token, phone: phone, code: code, password: password))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func loginWithPassword(_ commerce: String, phone: String, password: String) -> Single<UserModel> {
        return provider.rx.request(.loginWithPassword(commerce, phone: phone, password: password))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func loginOAuth(_ commerce: String, code: String, type: String) -> Single<UserModel> {
        return provider.rx.request(.loginOAuth(commerce, code: code, type: type))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func registerOAuth(_ token: String, type: String, openId: String, accessToken: String, phone: String, code: String) -> Single<UserModel> {
        return provider.rx.request(.registerOAuth(token, type: type, openId: openId, accessToken: accessToken, phone: phone, code: code))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func loginByCode(_ token: String, phone: String, code: String) -> Single<UserModel> {
        return provider.rx.request(.loginByCode(token, phone: phone, code: code))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func updateUserInfo(_ token: String, userToken: String, name: String = "", avatar: String = "") -> Single<UserModel> {
        return provider.rx.request(.updateUserInfo(token, userToken: userToken, name: name, avatar: avatar))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func modifyPhone(_ token: String, userToken: String, phone: String, code: String) -> Single<UserModel> {
        return provider.rx.request(.modifyPhone(token, userToken: userToken, phone: phone, code: code))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func modifyPassword(_ token: String, userToken: String, oldPassword: String, password: String) -> Single<UserModel> {
        return provider.rx.request(.modifyPassword(token, userToken: userToken, oldPassword: oldPassword, password: password))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func resetPassword(_ commerce: String, phone: String, code: String, password: String) -> Single<UserModel> {
        return provider.rx.request(.resetPassword(commerce, phone: phone, code: code, password: password))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func uploadFile(_ img:String) -> Single<UploadFile> {
        return provider.rx.request(.uploadFile(img))
            .filterSuccessfulStatusCodes()
            .mapObject(UploadFile.self)
    }
    func publishMood(_ commerce: String, userToken: String, note: String, address: String, lng: Double, lat: Double, money: Double, num: Int, imgs: [String], payType: String) -> Single<Published> {
        return provider.rx.request(.publishMood(commerce, userToken: userToken, note: note, address: address, lng: lng, lat: lat, money: money, num: num, imgs: imgs, payType: payType))
            .filterSuccessfulStatusCodes()
            .mapObject(Published.self)
    }
    func publishActivity(_ commerce: String, userToken: String, note: String, address: String, lng: Double, lat: Double, money: Double, num: Int, beginDate: Double, imgs: [String]) -> Single<UserModel> {
        return provider.rx.request(.publishActivity(commerce, userToken: userToken, note: note, address: address, lng: lng, lat: lat, money: money, num: num, beginDate: beginDate, imgs: imgs))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func getPublishedRedPackets(_ commerce: String, userToken: String, no: Int, size: Int) -> Single<RpRecordsResponse> {
        return provider.rx.request(.getPublishedRedPackets(commerce, userToken: userToken, no: no, size: size))
            .filterSuccessfulStatusCodes()
            .mapObject(RpRecordsResponse.self)
    }
    func getOpenedRedPackets(_ commerce: String, userToken: String, no: Int, size: Int) -> Single<RpRecordsResponse> {
        return provider.rx.request(.getOpenedRedPackets(commerce, userToken: userToken, no: no, size: size))
            .filterSuccessfulStatusCodes()
            .mapObject(RpRecordsResponse.self)
    }
    func getUserBankCards(_ commerce: String, userToken: String, no: Int, size: Int) -> Single<BankCardResponse> {
        return provider.rx.request(.getUserBankCards(commerce, userToken: userToken, no: no, size: size))
            .filterSuccessfulStatusCodes()
            .mapObject(BankCardResponse.self)
    }
    func addBackCard(_ commerce: String, userToken: String, bankName: String, bankNo: String, name: String, initBank: String) -> Single<BankCardResponse> {
        return provider.rx.request(.addBankCard(commerce, userToken: userToken, bankName: bankName, bankNo: bankNo, name: name, initBank: initBank))
            .filterSuccessfulStatusCodes()
            .mapObject(BankCardResponse.self)
    }
    func getCashRecords(_ commerce: String, userToken: String, no: Int, size: Int) -> Single<CashRecordsResponse> {
        return provider.rx.request(.getCashRecords(commerce, userToken: userToken, no: no, size: size))
            .filterSuccessfulStatusCodes()
            .mapObject(CashRecordsResponse.self)
    }
    func commerceApply(_ commerce: String, userToken: String, applyType: String, name: String, companyName: String, companyAddress: String, phone: String, job: String, logo: String, no: String, image: String, legalPerson: String) -> Single<UserModel> {
        return provider.rx.request(.commerceApply(commerce, userToken: userToken, applyType: applyType, name: name, companyName: companyName, companyAddress: companyAddress, phone: phone, job: job, logo: logo, no: no, image: image, legalPerson: legalPerson))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func addCommerceMemberApply(_ commerce: String, userToken: String, applyType: String, name: String, companyName: String, companyAddress: String, phone: String, job: String, no: String, image: String, legalPerson: String) -> Single<UserModel> {
        return provider.rx.request(.addCommerceMemberApply(commerce, userToken: userToken, applyType: applyType, name: name, companyName: companyName, companyAddress: companyAddress, phone: phone, job: job, no: no, image: image, legalPerson: legalPerson))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func updateAvatar(_ commerce: String, userToken: String, avatar: String) -> Single<UserModel> {
        return provider.rx.request(.updateAvatar(commerce, userToken: userToken, avatar: avatar))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func changePassword(_ commerce: String, userToken: String, oldPassword: String, password: String) -> Single<RpRecordsResponse> {
        return provider.rx.request(.changePassword(commerce, userToken: userToken, oldPassword: oldPassword, password: password))
            .filterSuccessfulStatusCodes()
            .mapObject(RpRecordsResponse.self)
    }
    func commerceApplyRecord(_ commerce: String, userToken: String, no: Int, size: Int) -> Single<MemberRecordResponse> {
        return provider.rx.request(.commerceApplyRecord(commerce, userToken: userToken, no: no, size: size))
            .filterSuccessfulStatusCodes()
            .mapObject(MemberRecordResponse.self)
    }
    func getRedPacketConfig(_ commerce: String, userToken: String) -> Single<RedPacketResponse> {
        return provider.rx.request(.getRedPacketConfig(commerce, userToken: userToken))
            .filterSuccessfulStatusCodes()
            .mapObject(RedPacketResponse.self)
    }
    func getEnrollConfig(_ commerce: String, userToken: String) -> Single<RedPacketResponse> {
        return provider.rx.request(.getRedPacketConfig(commerce, userToken: userToken))
            .filterSuccessfulStatusCodes()
            .mapObject(RedPacketResponse.self)
    }
    func attendActivity(_ commerce: String, userToken: String, id: Int, money: Double, payType: String) -> Single<Published> {
        return provider.rx.request(.attendActivity(commerce, userToken: userToken, id: id, money: money, payType: payType))
            .filterSuccessfulStatusCodes()
            .mapObject(Published.self)
    }
    func attendProject(_ commerce: String, userToken: String, id: Int, money: Double, payType: String) -> Single<Published> {
        return provider.rx.request(.attendProject(commerce, userToken: userToken, id: id, money: money, payType: payType))
            .filterSuccessfulStatusCodes()
            .mapObject(Published.self)
    }
    func withdraw(_ commerce: String, userToken: String, bankId: Int, money: Double) -> Single<WithdrawResponse> {
        return provider.rx.request(.withdraw(commerce, userToken: userToken, bankId: bankId, money: money))
            .filterSuccessfulStatusCodes()
            .mapObject(WithdrawResponse.self)
    }
    func getUserInfo(_ commerce: String, userToken: String) -> Single<UserModel> {
        return provider.rx.request(.getUserInfo(commerce, userToken: userToken))
            .filterSuccessfulStatusCodes()
            .mapObject(UserModel.self)
    }
    func getUserCommerceState(_ commerce: String, userToken: String) -> Single<CommerceState> {
        return provider.rx.request(.getUserCommerceState(commerce, userToken: userToken))
            .filterSuccessfulStatusCodes()
            .mapObject(CommerceState.self)
    }
}
