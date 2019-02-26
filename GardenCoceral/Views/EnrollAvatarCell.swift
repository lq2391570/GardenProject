//
//  EnrollAvatarCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/5/3.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import SwiftRichString

class EnrollAvatarCell: UITableViewCell, Reusable {

    var avatar = UIImageView()
    var name = UILabel()
    var avatarName:String?
    var memberModel:DynamicDetailMember!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _ = avatar.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerX.equalToSuperview()
                m.centerY.equalToSuperview()
                m.width.height.equalTo(60)
            })
        }
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(avatar.snp.bottom).offset(5)
                m.left.right.equalToSuperview().inset(15)
                m.height.greaterThanOrEqualTo(21)
            })
        }
       // setData(model: self.memberModel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension EnrollAvatarCell {
    func setData(model:DynamicDetailMember) {
    //    avatar.kf.setImage(with: URL(string: model.avatar ?? ""))
        avatar.sd_setImage(with: URL(string: model.avatar ?? ""), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: nil)
//        let n = getCurrentUser().name
//        let j = getCurrentUser().job
        let n = model.name
        let j = model.job
        let nameStr = ("\(n ?? "") - ").set(style: .default{
            $0.color = UIColor(hex: "#333")
            $0.font = FontAttribute(.AppleSDGothicNeo_Regular, size: 16)
            $0.align = .center
            }) + ("\(j ?? "")").set(style: .default{
                $0.color = UIColor(hex: "#666")
                $0.font = FontAttribute(.AppleSDGothicNeo_Regular, size: 16)
                $0.align = .center
                })
        name.attributedText = nameStr
    }
}
