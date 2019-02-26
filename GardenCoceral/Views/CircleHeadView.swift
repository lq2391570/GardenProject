//
//  CircleHeadView.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/3/28.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class CircleHeadView: UIView{

    var containerTop = UIView()
    var avatar = UIImageView()
    var identity = UILabel()
    var post = UILabel()
    var name = UILabel()
    var company = UILabel()
    var phone = UILabel()
    var address = UILabel()
    var midLine = UIView()
    var date = UILabel()
    var mood = UIButton()
    var activity = UIButton()
    var botLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        _ = containerTop.then{
            addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.top.equalToSuperview()
            })
            $0.backgroundColor = .white
        }

        _ = avatar.then{
            containerTop.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(30)
                m.left.equalTo(20)
                m.width.height.equalTo(75)
            })
            $0.cornerRadius = 75/2
        }

        _ = identity.then{
            containerTop.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(avatar.snp.bottom).offset(10)
                m.height.equalTo(30)
                m.centerX.equalTo(avatar.snp.centerX)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
        }

        _ = name.then{
            containerTop.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(avatar.snp.right).offset(10)
                m.height.equalTo(30)
                m.top.equalTo(avatar.snp.top)
                m.width.lessThanOrEqualTo(80)
            })
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor(hex: "#333")
        }

        _ = post.then{
            containerTop.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(name.snp.right).offset(5)
                m.height.equalTo(30)
                m.top.equalTo(name.snp.top)
                m.width.lessThanOrEqualTo(80)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(hex: "#666")
        }

        _ = company.then{
            containerTop.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.height.equalTo(30)
                m.right.equalTo(-20)
                m.top.equalTo(name.snp.top)
            })
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor(hex: "#666")
        }

        _ = phone.then{
            containerTop.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(avatar.snp.right).offset(10)
                m.height.equalTo(30)
                m.right.equalTo(-20)
                m.top.equalTo(name.snp.bottom).offset(10)
            })
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor(hex: "#666")
        }

        _ = address.then{
            containerTop.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(identity)
                m.bottom.equalTo(-20)
                m.right.equalTo(-20)
                m.left.equalTo(phone.snp.left)
                m.height.greaterThanOrEqualTo(30)
            })
            $0.numberOfLines = 2
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor(hex: "#999")
        }

        _ = midLine.then{
            addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(containerTop.snp.bottom).offset(10)
                m.left.right.equalTo(0)
                m.height.equalTo(1)
            })
            $0.backgroundColor = UIColor(hexString: "#ededed")
        }

        _ = date.then{
            addSubview(date)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(20)
                m.top.equalTo(midLine.snp.bottom).offset(30)
                m.height.equalTo(30)
            })
        }

        _ = botLine.then{
            addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.equalTo(0)
                m.height.equalTo(1)
                m.bottom.equalToSuperview()
            })
            $0.backgroundColor = UIColor(hexString: "#ededed")
        }

        _ = mood.then{
            addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(midLine.snp.bottom).offset(20)
                m.bottom.equalTo(botLine.snp.top).offset(-20)
                m.width.equalTo(110)
                m.height.equalTo(50)
                m.centerX.equalToSuperview().offset(-60)
            })
            $0.titleColorForNormal = .black
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.layoutButton(with: .left, imageTitleSpace: 8)
            $0.titleColorForNormal = UIColor(hex: "666")
        }

        _ = activity.then{
            addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(midLine.snp.bottom).offset(20)
                m.bottom.equalTo(botLine.snp.top).offset(-20)
                m.width.equalTo(110)
                m.height.equalTo(50)
                m.centerX.equalToSuperview().offset(80)
            })
            $0.titleColorForNormal = .black
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            $0.layoutButton(with: .left, imageTitleSpace: 8)
            $0.titleColorForNormal = UIColor(hex: "666")
        }
        
        setData()
    }
    
    func setData() {
        avatar.kf.setImage(with: URL(string: "https://img.yingjobs.com/upload/image/201803/14c5cfd4-ff3d-49ca-a918-be230426a324.png"))
        identity.text = "工会会长"
        name.text = "张三"
        post.text = "董事长"
        company.text = "观止科技"
        phone.text = "18282762627"
        address.text = "西安市未央区凤城六路"
        date.text = "今日"
        mood.titleForNormal = "发布心情"
        mood.imageForNormal = #imageLiteral(resourceName: "circle-mood-publish")
        activity.titleForNormal = "发起活动"
        activity.imageForNormal = #imageLiteral(resourceName: "circle-activity-publish")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
