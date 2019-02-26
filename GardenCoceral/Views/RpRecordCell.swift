//
//  RpRecordCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/18.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class RpRecordCell: UITableViewCell, Reusable {

    var date = UILabel()
    var content = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = backColor
        _ = date.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(10)
                m.bottom.equalTo(-10)
                m.left.equalTo(15)
                m.width.lessThanOrEqualTo(120)
            })
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor(hex: "#999")
        }
        _ = content.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerY.equalToSuperview()
                m.right.equalTo(-15)
                m.left.equalTo(date.snp.right).offset(10)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(hex: "#666")
            $0.numberOfLines = 0
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension RpRecordCell {
    func setData(_ model: RpRecordDetail) {
        date.text = model.date?.string ?? Date().dateString()
        content.text = (model.name ?? "") + "抢得" + (model.money?.string ?? "") + "元"
    }
}
