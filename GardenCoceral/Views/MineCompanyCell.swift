//
//  MineCompanyCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

class MineCompanyCell: UITableViewCell, Reusable {

    var avatar = UIImageView()
    var name = UILabel()
    var address = UILabel()
    var status = UIButton()
    var addBtn = UIButton()
    
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
                m.top.equalTo(avatar.snp.top).inset(12)
                m.right.equalTo(-15)
                m.width.equalTo(55)
                m.height.equalTo(22)
            })
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(avatar.snp.right).offset(15)
                m.top.equalTo(avatar.snp.top).inset(3)
                m.height.greaterThanOrEqualTo(22)
                m.right.equalTo(status.snp.left).inset(10)
            })
            name.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
            name.textColor = UIColor.white
        }
        
        _ = address.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(name)
                m.top.equalTo(name.snp.bottom).offset(5)
                m.height.greaterThanOrEqualTo(21)
                m.right.equalTo(name)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(hexString: "#666")
            $0.textColor = UIColor.white
        }
        
        _ = addBtn.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(name)
                m.top.equalTo(address.snp.bottom).offset(5)
                m.height.equalTo(23)
                m.width.equalTo(70)
            })
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(addMembers), for: .touchUpInside)
            $0.setTitleColor(UIColor.white, for: .normal)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension MineCompanyCell {
    func setData(_ model: UserModel) {
        avatar.kf.setImage(with: URL(string: model.avatar ?? ""), placeholder: #imageLiteral(resourceName: "koala-walk-1"))
        name.text = model.name ?? "地表最强公司"
        address.text = model.address ?? "来自火星"
        status.backgroundColor = UIColor.init(red: 172/255.0, green: 42/255.0, blue: 51/255.0, alpha: 1)
        
        status.titleForNormal = "管理员"
        status.titleColorForNormal = UIColor.white
        
        addBtn.titleForNormal = "添加成员"
        addBtn.titleColorForNormal = UIColor.white
        addBtn.borderColor = UIColor.white
        addBtn.borderWidth = 1
        
        
    }
    @objc func addMembers() {
        let vc = AddMemberController()
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
