//
//  FullLabelCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class FullLabelCell: UITableViewCell,Reusable {

    var name = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.top.bottom.equalTo(0)
                m.height.equalTo(60)
            })
            $0.textColor = UIColor(hexString: "#666")
            $0.font = UIFont.systemFont(ofSize: 17)
            $0.textAlignment = .center
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
