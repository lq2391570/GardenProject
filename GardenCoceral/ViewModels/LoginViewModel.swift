//
//  LoginViewModel.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/14.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    let disposeBag = DisposeBag()
    
    let phoneUsable: Driver<Result>
    let passwordUsable: Driver<Result>    //密码是否可用
    var loginButtonEnabled: Driver<Bool>
    var loginResult: Driver<Result>
    
    init(input:(
        phone: Driver<String>,
        password: Driver<String>,
        loginTap: Driver<Void>
        )) {
        
        phoneUsable = input.phone.map {
            phone in
//            guard phone.count > 0 else {
//                return Result.empty
//            }
//            return phone.isTelNumber() ? Result.ok(message: "ok") : Result.failed(message: "手机号不正确")
            return Result.ok(message: "ok")
        }
        
        passwordUsable = input.password.map {
            password in
            guard password.count > 0 else {
                return Result.empty
            }
            return password.count > 5 ? Result.ok(message: "ok") : Result.failed(message: "密码需要6位以上")
        }
        
        loginButtonEnabled = Driver.combineLatest(phoneUsable, passwordUsable) {
            (phone, password) in
                phone.isValid && password.isValid
            }.distinctUntilChanged()
        
        let phoneAndPassword = Driver.combineLatest(input.phone, input.password) {
            ($0, $1)
        }
        loginResult = input.loginTap.withLatestFrom(phoneAndPassword)
            .flatMapLatest({ (phone, password) in
                return MyService.shareInstance.loginWithPassword("1", phone: phone, password: password)
                    .flatMap({ (model) -> Single<Result> in
                        Log(model)
                        guard model.code == 0 else {
                            return Single.just(Result.failed(message: model.msg ?? "error"))
                        }
                        setCurrentUser(model)
                        return Single.just(Result.ok(message: "登录成功"))
                    }).asDriver(onErrorJustReturn: Result.failed(message: "error"))
            })
    }
}

