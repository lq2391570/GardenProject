//
//  WithdrawCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class WithdrawCell: UITableViewCell, Reusable {

    let disposeBag = DisposeBag()
    var balance = UILabel()
    var remaining = UILabel()
    var symbol = UILabel()
    var remainingInput = UITextField()
    var line = UIView()
    var hint = UILabel()
    var back: ((Double)->())?
    var money: Double?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        _ = balance.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(25)
                m.left.equalTo(15)
                m.width.equalTo(80)
                m.height.equalTo(21)
            })
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor(hexString: "#333")
            $0.text = "我的余额"
        }
        
        _ = remaining.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(balance.snp.bottom).offset(10)
                m.left.equalTo(balance)
                m.right.equalTo(-15)
                m.height.equalTo(60)
            })
            $0.font = UIFont.systemFont(ofSize: 50)
            $0.textColor = themeColor
        }
        
        _ = symbol.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(remaining.snp.bottom).offset(20)
                m.left.equalTo(balance)
                m.width.equalTo(30)
                m.height.equalTo(40)
            })
            $0.font = UIFont.systemFont(ofSize: 40)
            $0.textColor = UIColor(hexString: "#666")
            $0.text = "￥"
        }
        
        _ = remainingInput.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(symbol)
                m.left.equalTo(symbol.snp.right).offset(20)
                m.height.equalTo(symbol)
                m.right.equalTo(-15)
            })
            $0.placeholder = "请输入提现金额..."
            $0.font = UIFont.systemFont(ofSize: 18)
            $0.keyboardType = .decimalPad
            $0.rx.text.bind(onNext: { (text) in
                if let m = text?.double(), let money = self.money {
                    self.remainingInput.textColor = m <= money ? UIColor(hex: "#333") : .red
                    if let back = self.back {
                        back(m)
                    }
                }
                
            }).disposed(by: disposeBag)
        }
        
        _ = line.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(balance)
                m.right.equalTo(-15)
                m.top.equalTo(symbol.snp.bottom).offset(10)
                m.height.equalTo(1)
            })
            line.backgroundColor = lineColor
        }
        
        _ = hint.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(line.snp.bottom).offset(15)
                m.left.equalTo(remainingInput)
                m.right.equalTo(-15)
                m.bottom.equalTo(-15)
            })
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor(hexString: "#999")
            $0.text = "提现将会收取0.6%的手续费"
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension WithdrawCell {
    func setData(_ model: CashRecordsResponse) {
        self.money = model.money
        remaining.text = model.money?.string
        hint.text = "提现将会收取\(model.fee ?? 0)%的手续费"
    }
}
