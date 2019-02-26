//
//  ActivityPubCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/3.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import ImagePicker
import SKPhotoBrowser
import RxSwift

class ActivityPubCell: UITableViewCell, Reusable {

    let disposeBag = DisposeBag()
    var textView = UITextView()
    let cellLayout = UICollectionViewFlowLayout()
    var imgPickView: UICollectionView!
    var imgsPath = [String]()
    var tableView = UITableView()
    var lineOne = UIView()
    var locLabel = UILabel()
    var locBtn = UIButton()
    var lineTwo = UIView()
    var dateLabel = UILabel()
    var dateBtn = UIButton()
    var lineThree = UIView()
    var numLabel = UILabel()
    var numTextField = UITextField()
    var selectedDate = Date()
    var backImgs: (([String])->())?
    var backDate: ((Date)->())?
    var backNote: ((String)->())?
    var backNum: ((String)->())?
    var backPoi: ((AMapPOI)->())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        _ = textView.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.top.equalToSuperview().inset(15)
                m.height.equalTo(85)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.placeholder = "请输入详细的活动内容..."
            $0.rx.text.bind{ text in
                if let back = self.backNote {
                    back(text ?? "")
                }
            }.disposed(by: disposeBag)
        }
        let itemWidth = (windowWidth-45)/4
        _ = cellLayout.then{
            $0.scrollDirection = .vertical
            $0.itemSize = CGSize(width: itemWidth, height: itemWidth)
            $0.minimumLineSpacing = 1
            $0.minimumInteritemSpacing = 1
        }
        imgPickView = UICollectionView(frame: .zero, collectionViewLayout: cellLayout).then{
            contentView.addSubview($0)
            
            $0.snp.makeConstraints({ (m) in
                m.left.right.equalTo(textView)
                m.top.equalTo(textView.snp.bottom).offset(15)
                m.height.equalTo(itemWidth)
            })
            $0.delegate = self
            $0.dataSource = self
            $0.register(nibWithCellClass: MoodPubImgCell.self)
            $0.backgroundColor = .white
        }
        _ = lineOne.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.equalTo(textView)
                m.top.equalTo(imgPickView.snp.bottom).offset(10)
                m.height.equalTo(1)
            })
            $0.backgroundColor = lineColor
        }
        _ = locLabel.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(textView)
                m.top.equalTo(lineOne.snp.bottom).offset(10)
                m.height.equalTo(30)
                m.width.equalTo(80)
            })
            $0.text = "活动地址"
        }
        _ = locBtn.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(locLabel.snp.right).offset(15)
                m.right.equalTo(textView)
                m.height.equalTo(locLabel)
                m.top.equalTo(locLabel)
            })
            $0.titleForNormal = "点击地图选择"
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.titleColorForNormal = UIColor(hexString: "#8599b2")
            $0.contentHorizontalAlignment = .left
            $0.addTarget(self, action: #selector(placeSelect(_:)), for: .touchUpInside)
        }
        _ = lineTwo.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.equalTo(textView)
                m.top.equalTo(locLabel.snp.bottom).offset(10)
                m.height.equalTo(1)
            })
            $0.backgroundColor = lineColor
        }
        _ = dateLabel.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(textView)
                m.top.equalTo(lineTwo.snp.bottom).offset(10)
                m.height.equalTo(30)
                m.width.equalTo(80)
            })
            $0.text = "活动时间"
        }
        _ = dateBtn.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(dateLabel.snp.right).offset(15)
                m.right.equalTo(textView)
                m.height.equalTo(dateLabel)
                m.top.equalTo(dateLabel)
            })
            $0.titleForNormal = "请选择日期"
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.titleColorForNormal = UIColor.lightGray
            $0.contentHorizontalAlignment = .left
            $0.titleForNormal = selectedDate.string(withFormat: "yyyy-MM-dd HH:mm")
            $0.addTarget(self, action: #selector(dateSelect(_:)), for: .touchUpInside)
        }
        _ = lineThree.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.equalTo(textView)
                m.top.equalTo(dateLabel.snp.bottom).offset(10)
                m.height.equalTo(1)
            })
            $0.backgroundColor = lineColor
        }
        _ = numLabel.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(textView)
                m.top.equalTo(lineThree.snp.bottom).offset(10)
                m.height.equalTo(30)
                m.width.equalTo(80)
                m.bottom.equalTo(-15)
            })
            $0.text = "参与人数"
        }
        _ = numTextField.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(numLabel.snp.right).offset(15)
                m.right.equalTo(textView)
                m.height.equalTo(numLabel)
                m.top.equalTo(numLabel)
            })
            $0.placeholder = "请输入限制人数(不设置表示不限制)"
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.keyboardType = .numberPad
            $0.rx.text.bind{ text in
                if let back = self.backNum {
                    back(text ?? "0")
                }
            }.disposed(by: disposeBag)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ActivityPubCell {
    @objc func placeSelect(_ btn: UIButton) {
        let vc = PlaceSelectController()
        vc.backPlace = { poi in
            self.locBtn.titleForNormal = poi.name ?? ""
            if let back = self.backPoi {
                back(poi)
            }
        }
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func dateSelect(_ btn: UIButton) {
        let alert = UIAlertController(style: .actionSheet, title: "Select date")
        alert.addDatePicker(mode: .dateAndTime, date: selectedDate, minimumDate: Date(), maximumDate: nil) { date in
            self.selectedDate = date
            if let back = self.backDate {
                back(self.selectedDate)
            }
            btn.titleForNormal = date.string(withFormat: "yyyy-MM-dd HH:mm")
        }
        alert.addAction(title: "确定", style: .cancel)
        alert.show()
    }
}
extension ActivityPubCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgsPath.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as MoodPubImgCell
        if indexPath.row == imgsPath.count {
            cell.img.image = #imageLiteral(resourceName: "mood_pub_img")
            cell.deleteBtn.imageForNormal = nil
        }else {
            cell.img.image = UIImage(contentsOfFile: imgsPath[indexPath.row])
            cell.deleteBtn.imageForNormal = #imageLiteral(resourceName: "photo-close")
            cell.deletePhoto = {
                self.imgsPath.remove(at: indexPath.row)
                collectionView.reloadData {
                    self.reload()
                }
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == imgsPath.count {
            alertPicker()
        }else {
            alertBrower(indexPath.row)
        }
    }
}
extension ActivityPubCell {
    func alertPicker() {
        var configuration = Configuration()
        configuration.cancelButtonTitle = "取消"
        configuration.doneButtonTitle = "完成"
        configuration.noImagesTitle = "貌似还没有图片哦！"
        configuration.recordLocation = false
        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 9 - imgsPath.count
        parentViewController?.present(imagePickerController, animated: true, completion: nil)
    }
    func alertBrower(_ index: Int) {
        let photos = imgsPath.map{
            return SKPhoto.photoWithImage(UIImage(contentsOfFile: $0)!)
        }
        SKPhotoBrowserOptions.enableSingleTapDismiss = true
        let brower = SKPhotoBrowser(photos: photos, initialPageIndex: index)
        parentViewController?.present(brower, animated: true, completion: nil)
    }
}
extension ActivityPubCell: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count != 0 else { return }
        let photos = images.map{
            return SKPhoto.photoWithImage($0)
        }
        SKPhotoBrowserOptions.enableSingleTapDismiss = true
        let brower = SKPhotoBrowser(photos: photos, initialPageIndex: 0)
        imagePicker.present(brower, animated: true, completion: nil)
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imgsPath = imgsPath + images.map { (img) -> String in
            if let imgData = UIImageJPEGRepresentation(img, 0.1) {
                let fullPath = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).jpg"
                let url = URL(fileURLWithPath: fullPath)
                do {
                    try imgData.write(to: url, options: .atomic)
                    Log(fullPath)
                    return fullPath
                } catch {
                    Log(error)
                }
            }
            return ""
            }.filter{$0 != ""}
        imgPickView.reloadData {
            self.reload()
        }
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
extension ActivityPubCell {
    func reload() {
        let height = self.imgPickView.collectionViewLayout.collectionViewContentSize.height
        self.imgPickView.snp.updateConstraints({ (m) in
            m.height.equalTo(height)
        })
        self.updateConstraintsIfNeeded()
        self.tableView.reloadData()
        if let back = self.backImgs {
            back(self.imgsPath)
        }
    }
}
