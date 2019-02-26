//
//  OneTextFieldCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class OneTextFieldCell: UITableViewCell, Reusable {

    let disposeBag = DisposeBag()
    var textField = UITextField()
    var back: ((String)->())?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = textField.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(15)
                m.top.bottom.equalTo(0)
                m.right.equalTo(-15)
            })
            $0.textColor = UIColor(hexString: "#666")
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.clearButtonMode = .whileEditing
            $0.rx.text.bind(onNext: { (text) in
                if let back = self.back {
                    back(text ?? "")
                }
            }).disposed(by: disposeBag)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
