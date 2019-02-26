//
//  CircleHeadCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/2.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import SKPhotoBrowser

class CircleHeadCell: UITableViewCell, Reusable {

    var date = UILabel()
    var content = UILabel()
    var imgsContainer = UIView()
    var images = [SKPhoto]()
    var lineView = UIView()
    var expandBtn = UIButton()
    var commentBtn = UIButton()
    var likeBtn = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        _ = content.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(10)
                m.left.equalTo(60)
                m.right.equalTo(-15)
            })
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 13)
        }
        
        _ = imgsContainer.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(content.snp.bottom).offset(10)
                m.left.right.equalTo(content)
            })
        }
        
        _ = lineView.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(imgsContainer.snp.bottom).offset(10)
                m.right.equalToSuperview()
                m.left.equalTo(content)
                m.height.equalTo(1)
            })
            $0.backgroundColor = UIColor(hexString: "#ededed")
        }
        _ = expandBtn.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.right.equalTo(content)
                m.top.equalTo(lineView.snp.bottom).offset(10)
                m.width.height.equalTo(25)
                m.bottom.equalTo(-10)
            })
            $0.imageForNormal = #imageLiteral(resourceName: "icon_big_arrow")
        }
        
        _ = likeBtn.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.right.equalTo(expandBtn.snp.left).offset(-5)
                m.top.equalTo(expandBtn)
                m.width.equalTo(40)
                m.height.equalTo(25)
            })
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            $0.titleColorForNormal = UIColor(hexString: "#666")
        }
        
        _ = commentBtn.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.right.equalTo(likeBtn.snp.left).offset(-5)
                m.top.equalTo(expandBtn)
                m.width.equalTo(40)
                m.height.equalTo(25)
            })
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            $0.titleColorForNormal = UIColor(hexString: "#666")
        }
        
        _ = date.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(10)
                m.centerY.equalToSuperview()
                m.right.equalTo(content.snp.left).offset(-10)
            })
        }
    }
    public func setData(_ model: [String: Any]) {
    
        date.text = model["date"] as? String
        content.text = model["note"] as? String
        likeBtn.titleForNormal = "10"
        likeBtn.imageForNormal = #imageLiteral(resourceName: "icon_thumbup")
        
        commentBtn.titleForNormal = "10"
        commentBtn.imageForNormal = #imageLiteral(resourceName: "icon_comment")
        
        imgsContainer.removeSubviews()
        images.removeAll()
        
        let imgs = model["imgs"] as! [String]
        var keyViews = [UIImageView]()
        for (ip, it) in imgs.enumerated(){
            _ = UIImageView().then{
                imgsContainer.addSubview($0)
                keyViews.append($0)
                $0.snp.makeConstraints({ (m) in
                    
                    let row = ip / 3
                    let col = ip % 3
                    //添加垂直位置约束
                    if row == 0{
                        m.top.equalTo(0)
                    }else{
                        m.top.equalTo(keyViews[ip-3].snp.bottom).offset(5)
                    }
                    //点睛之笔，自动约束的精髓所在
                    if ip == imgs.count - 1 {
                        m.bottom.equalTo(0)
                    }
                    
                    if (imgs.count > 2) {
                        m.width.height.equalTo(imgsContainer.snp.width).dividedBy(3).inset(5)
                        //添加水平位置约束
                        switch (col) {
                        case 0:
                            m.left.equalTo(imgsContainer.snp.left).offset(10)
                        case 1:
                            m.centerX.equalTo(imgsContainer.snp.centerX)
                        case 2:
                            m.right.equalTo(imgsContainer.snp.right).offset(-10)
                        default:
                            break
                        }
                    }else {
                        m.width.height.equalTo(imgsContainer.snp.width).dividedBy(2).inset(5)
                        //添加水平位置约束
                        switch (col) {
                        case 0:
                            m.left.equalTo(imgsContainer.snp.left).offset(10)
                        case 1:
                            m.right.equalTo(imgsContainer.snp.right).offset(-10)
                        default:
                            break
                        }
                    }
                    
                })
                $0.kf.setImage(with: URL(string: it))
                $0.clipsToBounds = true
                $0.contentMode = .scaleAspectFill
                $0.tag = ip + 100
                $0.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
                $0.addGestureRecognizer(tap)
                let photo = SKPhoto.photoWithImageURL(it)
                photo.shouldCachePhotoURLImage = true
                images.append(photo)
            }
        }
    }
    @objc func handleTap(tap: UITapGestureRecognizer) {
        SKPhotoBrowserOptions.enableSingleTapDismiss = true
        let blower = SKPhotoBrowser(photos: images, initialPageIndex: (tap.view?.tag)! - 100)
        parentViewController?.present(blower, animated: true, completion: {})
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
