//
//  CirclePayCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/11.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class CirclePayCell: UITableViewCell, Reusable {

    var logo = UIImageView()
    var name = UILabel()
    var intro = UILabel()
    var select = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = logo.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(20)
                m.top.equalTo(15)
                m.width.height.equalTo(40)
                m.bottom.equalTo(-15)
            })
        }
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(logo.snp.right).offset(20)
                m.centerY.equalToSuperview()
                m.width.lessThanOrEqualTo(50)
            })
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor(hex: "#666")
        }
        _ = select.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.right.equalTo(-20)
                m.centerY.equalToSuperview()
                m.width.height.equalTo(15)
            })
        }
        _ = intro.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(name.snp.right).offset(15)
                m.centerY.equalToSuperview()
                m.right.equalTo(select.snp.left).inset(15)
            })
            $0.font = UIFont.systemFont(ofSize: 25)
            $0.textColor = UIColor(hex: "#fd903b")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CirclePayCell {
    func setData(_ model: CirclePay) {
        logo.image = UIImage(named: model.logo ?? "")
        name.text = model.name
        intro.text = model.intro
        select.image = model.select! ? #imageLiteral(resourceName: "payway-select") : #imageLiteral(resourceName: "payway-unselect")
    }
}
