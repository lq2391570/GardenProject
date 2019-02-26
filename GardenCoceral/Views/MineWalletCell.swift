//
//  MineWalletCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/13.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class MineWalletCell: UITableViewCell, Reusable {

    var caption = UILabel()
    var amount = UILabel()
    var withdrawBtn = UIButton()
    var response: CashRecordsResponse?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = caption.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(25)
                m.left.equalTo(15)
                m.width.greaterThanOrEqualTo(100)
            })
            $0.textColor = UIColor(hexString: "#333")
            $0.text = "我的余额"
        }
        _ = withdrawBtn.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(caption.snp.bottom).offset(20)
                m.right.equalTo(-15)
                m.width.equalTo(80)
                m.height.equalTo(35)
            })
            $0.borderColor = themeColor
            $0.borderWidth = 1
            $0.cornerRadius = 2
            $0.titleColorForNormal = themeColor
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.titleForNormal = "提现"
            $0.addTarget(self, action: #selector(withdrawClick), for: .touchUpInside)
        }
        _ = amount.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(caption)
                m.top.equalTo(caption.snp.bottom).offset(15)
                m.right.equalTo(withdrawBtn.snp.left).inset(15)
                m.bottom.equalTo(-16)
            })
            $0.font = UIFont.systemFont(ofSize: 50)
            $0.textColor = themeColor
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension MineWalletCell {
    func setData(_ model: CashRecordsResponse) {
        response = model
        amount.text = model.money?.string
    }
    @objc func withdrawClick() {
        let vc = WalletViewController()
        vc.cashResponse = response
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
