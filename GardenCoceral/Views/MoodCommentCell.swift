//
//  MoodCommentCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/3/30.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable

class MoodCommentCell: UITableViewCell, Reusable {

    var commentView = UIView()
    var commentLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        _ = commentView.then{
            addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(60)
                m.right.equalTo(-15)
                m.top.equalTo(0)
                m.bottom.equalTo(0)
            })
            $0.backgroundColor = UIColor(hexString: "#ededed")
        }
        _ = commentLabel.then{
            commentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(3)
                m.right.equalTo(-3)
                m.top.equalTo(3)
                m.bottom.equalTo(-3)
            })
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor(hexString: "#666")
        }
    }
    
    func setData(_ model: String) {
        commentLabel.text = model
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
