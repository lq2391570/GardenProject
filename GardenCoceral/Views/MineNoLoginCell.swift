//
//  MineNoLoginCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/13.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

import Reusable

class MineNoLoginCell: UITableViewCell, Reusable {
    
    var avatar = UIImageView()
    var status = UIButton()
    var back: (()->())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = avatar.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.width.height.equalTo(80)
                m.left.equalTo(15)
                m.top.equalTo(25)
                m.bottom.equalTo(-25)
            })
            $0.cornerRadius = 40
        }
        
        _ = status.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(avatar.snp.right).offset(15)
                m.centerY.equalTo(avatar.snp.centerY)
                m.width.equalTo(55)
            })
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
        setData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MineNoLoginCell {
    func setData() {
        avatar.image = #imageLiteral(resourceName: "koala-walk-1")
        status.backgroundColor = themeColor
        status.titleForNormal = "登录"
        status.titleColorForNormal = UIColor.white
    }
    @objc func login() {
        let vc = LoginController()
        vc.back = {
            if let back = self.back {
                back()
            }
        }
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
