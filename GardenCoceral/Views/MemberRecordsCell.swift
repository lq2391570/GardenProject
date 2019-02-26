//
//  MemberRecordsCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class MemberRecordsCell: UITableViewCell, Reusable {

    var name = UILabel()
    var status = UILabel()
    var job = UILabel()
    var date = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(15)
                m.top.equalTo(20)
                m.width.greaterThanOrEqualTo(100)
            })
            $0.font = UIFont.systemFont(ofSize: 17)
            $0.textColor = UIColor(hexString: "#333")
        }
        _ = status.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.right.equalTo(-15)
                m.top.equalTo(20)
                m.width.greaterThanOrEqualTo(100)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(hexString: "#999")
            $0.textAlignment = .right
        }
        _ = job.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(name)
                m.top.equalTo(name.snp.bottom).offset(10)
                m.width.greaterThanOrEqualTo(100)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(hexString: "#666")
        }
        _ = date.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.right.equalTo(status)
                m.top.equalTo(status.snp.bottom).offset(10)
                m.width.greaterThanOrEqualTo(100)
                m.bottom.equalTo(-20)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(hexString: "#999")
            $0.textAlignment = .right
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MemberRecordsCell {
    func setData(_ record: CashRecord) {
        name.text = record.title
        status.text = record.money?.string
        job.text = record.note
        date.text = record.date
    }
    func setData2(_ record: MemberRecord) {
        name.text = record.name
        status.text = record.state
        job.text = record.job
        date.text = record.date
    }
}
