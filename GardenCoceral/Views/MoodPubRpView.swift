//
//  MoodPubRpView.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/2.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import ObjectMapper
import Reusable
import RxSwift

class MoodPubRpView: UITableViewCell, Reusable {

    let disposeBag = DisposeBag()
    let cellLayout = UICollectionViewFlowLayout()
    var rpView: UICollectionView!
    var moneyText = UITextField()
    var midLine = UIView()
    var numText = UITextField()
    var backRedpacket: ((Int,Double)->())?
    var selectedIndex: Int?
    
    var rpArr = [
        RedPacket(1,money: 100,selected: false),
        RedPacket(5,money: 100,selected: false),
        RedPacket(10,money: 100,selected: false),
        RedPacket(20,money: 50,selected: false),
        RedPacket(50,money: 20,selected: false),
        RedPacket(100,money: 10,selected: false)
    ]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let itemWidth = (windowWidth-50)/3
        _ = cellLayout.then{
            $0.scrollDirection = .vertical
            $0.itemSize = CGSize(width: itemWidth, height: itemWidth/2)
            $0.minimumLineSpacing = 10
            $0.minimumInteritemSpacing = 10
        }
        rpView = UICollectionView(frame: .zero, collectionViewLayout: cellLayout).then{
            contentView.addSubview($0)
            
            $0.snp.makeConstraints({ (m) in
                m.left.right.equalToSuperview().inset(10)
                m.top.equalTo(10)
                m.height.equalTo(itemWidth+10)
            })
            $0.delegate = self
            $0.dataSource = self
            $0.register(nibWithCellClass: MoodPubRpCell.self)
            $0.backgroundColor = .white
        }
        _ = moneyText.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(rpView.snp.bottom).offset(10)
                m.left.right.equalTo(rpView).inset(5)
                m.height.equalTo(30)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.placeholder = "其他金额"
            $0.keyboardType = .numberPad
            $0.rx.text.orEmpty.bind { text in
                if let back = self.backRedpacket {
                    back(self.numText.text?.int ?? 0,text.double() ?? 0.0)
                }
                if let index = self.selectedIndex {
                    self.rpArr[index].selected = false
                    self.rpView.reloadData()
                    self.selectedIndex = nil
                }
            }.disposed(by: disposeBag)
        }
        _ = midLine.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(moneyText.snp.bottom).offset(10)
                m.left.right.equalTo(rpView)
                m.height.equalTo(1)
            })
            $0.backgroundColor = UIColor(hexString: "#ededed")
        }
        _ = numText.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(midLine.snp.bottom).offset(10)
                m.left.right.equalTo(rpView).inset(5)
                m.height.equalTo(30)
                m.bottom.equalTo(-10)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.placeholder = "红包个数"
            $0.keyboardType = .numberPad
            $0.rx.text.orEmpty.bind { text in
                
                if let back = self.backRedpacket {
                    back(text.int ?? 0,self.moneyText.text?.double() ?? 0.0)
                }
                if let index = self.selectedIndex {
                    self.rpArr[index].selected = false
                    self.rpView.reloadData()
                    self.selectedIndex = nil
                }
            }.disposed(by: disposeBag)
        }
        dealData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func dealData() {
        MyService.shareInstance.getRedPacketConfig("1", userToken: getCurrentUser().userToken ?? "")
            .subscribe(onSuccess: { (model) in
                if model.code == 0, let list = model.list {
                    self.rpArr = list
                    self.rpView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
}
extension MoodPubRpView: UICollectionViewDelegate, UICollectionViewDataSource {
    func resetRedPacket() {
        self.moneyText.text = ""
        self.numText.text = ""
        rpArr = rpArr.map{ it in
            var item = it
            item.selected = false
            return item
        }
        self.rpView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rpArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as MoodPubRpCell
        let rp = rpArr[indexPath.row]
        if rp.selected == true {
            if self.selectedIndex == nil {
                self.selectedIndex = indexPath.row
                let rp = rpArr[indexPath.row]
                if let back = self.backRedpacket {
                    back(rp.num ?? 0,rp.money?.double ?? 0.0)
                }
            }
            cell.money.textColor = .white
            cell.num.textColor = .white
            cell.contentView.backgroundColor = primaryBtnColor
        }else {
            cell.money.textColor = primaryBtnColor
            cell.num.textColor = UIColor(hexString: "#999")
            cell.contentView.backgroundColor = UIColor.white
        }
        cell.money.text = "\(rp.money ?? 0)元"
        cell.num.text = "\(rp.num ?? 0)个"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let rp = rpArr[indexPath.row]
        if let back = self.backRedpacket {
            back(rp.num ?? 0,rp.money?.double ?? 0.0)
        }
        rpArr = rpArr.enumerated().map{ (ip,it) in
            var item = it
            item.selected = ip == indexPath.row ? true : false
            return item
        }
        collectionView.reloadData()
        numText.text = ""
        moneyText.text = ""
    }
}
