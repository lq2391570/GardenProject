//
//  LeftMaginCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class LeftMaginCell: UITableViewCell, Reusable {

    var name = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(60)
                m.top.right.bottom.equalTo(0)
                m.height.equalTo(60)
            })
            $0.font = UIFont.systemFont(ofSize: 17)
            $0.textColor = UIColor(hexString: "#333")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
