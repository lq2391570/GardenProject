//
//  EnrollOfficialRpCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/5/4.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class EnrollOfficialRpCell: UITableViewCell, Reusable {

    var money = UILabel()
    var payWayLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _ = money.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(25)
                m.top.equalTo(35)
                m.right.equalTo(-25)
            })
            $0.textColor = UIColor(hex: "#666")
            $0.font = UIFont.systemFont(ofSize: 25)
            $0.text = "支付￥"
        }
        _ = payWayLabel.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(money.snp.bottom).offset(25)
                m.left.right.equalTo(money)
                m.height.equalTo(21)
                m.bottom.equalTo(-10)
            })
            $0.text = "支付方式"
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(hex: "#999")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension EnrollOfficialRpCell {
    func setData(_ money: String) {
        self.money.text = "支付￥\(money)"
    }
}
