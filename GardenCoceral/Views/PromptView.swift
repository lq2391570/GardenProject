//
//  Prompt.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/5/8.
//  Copyright © 2018年 tongna. All rights reserved.
//

import Foundation
import RxSwift

class PromptView: UIView {
    
    let disposeBag = DisposeBag()
    var logo = UIImageView()
    var prompt = UILabel()
    var confirmBtn = UIButton()
    var confirmClick: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 5
        _ = logo.then{
            addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(h(50))
                m.centerX.equalToSuperview()
                m.width.height.equalTo(70)
            })
            $0.image = #imageLiteral(resourceName: "红包")
        }
        _ = prompt.then{
            addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerX.equalToSuperview()
                m.top.equalTo(logo.snp.bottom).offset(h(25))
                m.left.right.equalToSuperview()
            })
            $0.textAlignment = .center
        }
        _ = confirmBtn.then{
            addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerX.equalToSuperview()
                m.width.equalTo(w(150))
                m.height.equalTo(h(50))
                m.bottom.equalTo(-h(50))
            })
            $0.backgroundColor = primaryBtnColor
            $0.titleColorForNormal = .white
            $0.titleForNormal = "好的"
            $0.rx.tap.bind{
                if let click = self.confirmClick {
                    click()
                }
            }.disposed(by: disposeBag)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension PromptView {
    func setData(_ prompt: String) {
        self.prompt.text = prompt
    }
}
