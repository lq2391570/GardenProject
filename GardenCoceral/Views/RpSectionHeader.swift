//
//  RpSectionHeader.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/18.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import SwiftRichString

class RpSectionHeader: UITableViewHeaderFooterView, Reusable {

    let disposeBag = DisposeBag()
    var date = UILabel()
    var moneyLabel = UILabel()
    var money = UILabel()
    var count = UILabel()
    var arrowDown = UIImageView()
    var bottomLine = UIView()
    var upperBtn = UIButton()
    var select: (()->())?
    var expand = false
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        _ = date.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(15)
                m.bottom.equalTo(-15)
                m.left.equalTo(15)
                m.width.equalTo(55)
            })
            $0.textColor = UIColor(hex: "#666")
            
        }
        _ = arrowDown.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerY.equalToSuperview()
                m.right.equalTo(-15)
                m.height.equalTo(15)
                m.width.equalTo(12)
            })
            $0.image = #imageLiteral(resourceName: "arrow-right")
        }
        _ = count.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerY.equalToSuperview()
                m.right.equalTo(arrowDown.snp.left)
                m.width.equalTo(65)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        _ = moneyLabel.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerY.equalToSuperview()
                m.left.equalTo(date.snp.right).offset(15)
                m.width.equalTo(70)
            })
            $0.textColor = UIColor(hex: "#999")
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.text = "红包金额:"
        }
        _ = money.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerY.equalToSuperview()
                m.left.equalTo(moneyLabel.snp.right)
                m.right.equalTo(count.snp.left)
            })
            $0.textColor = UIColor(hex: "#999")
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        _ = bottomLine.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(date.snp.right).offset(10)
                m.right.equalTo(0)
                m.bottom.equalTo(0)
                m.height.equalTo(1)
            })
            $0.backgroundColor = lineColor
        }
        upperBtn = UIButton(type: .custom).then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.top.bottom.equalToSuperview()
            })
            $0.rx.tap.bind{
                if let select = self.select {
                    select()
                }
            }.disposed(by: disposeBag)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension RpSectionHeader {
    func setData(_ model: RpRecord) {
        expand = model.expand ?? false
        if !expand {
            arrowDown.transform = CGAffineTransform.identity
            bottomLine.backgroundColor = lineColor
        }else {
            arrowDown.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi/2))
            bottomLine.backgroundColor = UIColor(hex: "#ededed", alpha: 0)
        }
        let time = Date(timeIntervalSince1970: (model.addDate ?? 1000)/1000)
        let day = time.day.string.count == 1 ? "0\(time.day)" : time.day.string
        let dateStr = ("\(day)").set(style: .default{
            $0.font = FontAttribute(.GillSans_SemiBold, size: 25)
            }) + ("\(time.month)月").set(style: .default{
                $0.font = FontAttribute(.GillSans_SemiBold, size: 15)
                })
        date.attributedText = dateStr
        money.text = model.money?.string
        let countStr = ("\(model.openNum ?? 0)/").set(style: .default{
            $0.color = UIColor(hex: "#999")
            $0.align = .center
            }) + ("\(model.num ?? 0)").set(style: .default{
                $0.color = UIColor(hex: "#666")
                $0.align = .center
                })
        count.attributedText = countStr
    }
}
