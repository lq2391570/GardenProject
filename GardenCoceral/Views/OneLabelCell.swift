//
//  OneLabelCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class OneLabelCell: UITableViewCell, Reusable {

    var name = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(15)
                m.top.bottom.equalTo(0)
                m.right.equalTo(-15)
            })
            $0.textColor = UIColor(hexString: "#666")
            $0.font = UIFont.systemFont(ofSize: 16)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
