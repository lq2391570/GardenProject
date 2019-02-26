//
//  MineActionCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class MineActionCell: UITableViewCell, Reusable {

    var logo = UIImageView()
    var name = UILabel()
    var arrow = UIImageView()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = logo.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(15)
                m.top.equalTo(20)
                m.bottom.equalTo(-20)
                m.width.height.equalTo(20)
            })
        }
        
        _ = arrow.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.right.equalTo(-15)
                m.centerY.equalToSuperview()
                m.width.height.equalTo(20)
            })
        }
        
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(logo.snp.right).offset(20)
                m.centerY.equalToSuperview()
                m.right.equalTo(arrow.snp.left).inset(20)
            })
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
