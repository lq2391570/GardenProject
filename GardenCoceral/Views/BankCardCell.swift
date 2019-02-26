//
//  BankCardCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class BankCardCell: UITableViewCell, Reusable {

    var icon = UIImageView()
    var radio = UIImageView()
    var bankName = UILabel()
    var cardNumber = UILabel()
    var name = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        _ = bankName.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(10)
                m.left.equalTo(100)
                m.width.lessThanOrEqualTo(200)
                m.height.equalTo(21)
            })
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor(hexString: "#333")
        }
        _ = cardNumber.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(bankName)
                m.left.equalTo(bankName.snp.right).offset(10)
                m.width.equalTo(100)
                m.height.equalTo(21)
            })
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor(hexString: "#333")
        }
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(bankName.snp.bottom).offset(10)
                m.left.equalTo(bankName)
                m.width.lessThanOrEqualTo(200)
                m.height.equalTo(21)
                m.bottom.equalTo(-10)
            })
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor(hexString: "#999")
        }
        _ = radio.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(15)
                m.width.height.equalTo(15)
                m.centerY.equalToSuperview()
            })
        }
        
        _ = icon.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerY.equalToSuperview()
                m.width.height.equalTo(40)
                m.left.equalTo(45)
            })
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension BankCardCell {
    func setData(_ model: BankCard) {
        bankName.text = model.bankName
        cardNumber.text = "(\(model.bankNo ?? ""))"
        name.text = model.name
        icon.kf.setImage(with: URL(string: model.icon ?? ""), placeholder: #imageLiteral(resourceName: "头像"))
    }
}
