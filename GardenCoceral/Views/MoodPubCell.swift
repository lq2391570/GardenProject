//
//  MoodPubCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/2.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import ImagePicker
import SKPhotoBrowser
import RxSwift

class MoodPubCell: UITableViewCell, Reusable {
    
    let disposeBag = DisposeBag()
    var textView = UITextView()
    let cellLayout = UICollectionViewFlowLayout()
    var imgPickView: UICollectionView!
    var imgsPath = [String]()
    var tableView = UITableView()
    var midLine = UIView()
    var locLogo = UIImageView()
    var locLabel = UILabel()
    var locArrow = UIImageView()
    var locStr: String?
    var backImgs: (([String])->())?
    var backNote: ((String)->())?
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
            $0.placeholder = "分享你现在的心情..."
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
        _ = midLine.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.equalTo(textView)
                m.top.equalTo(imgPickView.snp.bottom).offset(10)
                m.height.equalTo(1)
            })
            $0.backgroundColor = UIColor(hexString: "#ededed")
        }
        _ = locLabel.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(50)
                m.right.equalTo(-35)
                m.top.equalTo(midLine.snp.bottom).offset(7)
                m.height.equalTo(30)
                m.bottom.equalTo(-7)
            })
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor(hexString: "#666")
            $0.text = locStr ?? "所在位置"
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer()
            tap.addTarget(self, action: #selector(palceSelect))
            $0.addGestureRecognizer(tap)
        }
        _ = locLogo.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(textView)
                m.width.height.equalTo(15)
                m.centerY.equalTo(locLabel.snp.centerY)
            })
            $0.image = #imageLiteral(resourceName: "位置（不显示）")
        }
        _ = locArrow.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.right.equalTo(textView)
                m.width.height.equalTo(15)
                m.centerY.equalTo(locLabel.snp.centerY)
            })
            $0.image = #imageLiteral(resourceName: "arrow-right")
        }
    }
    @objc func palceSelect() {
        let vc = PlaceSelectController()
        vc.backPlace = { poi in
            self.locLabel.text = poi.name ?? ""
            if let back = self.backPoi {
                back(poi)
            }
        }
        parentViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MoodPubCell: UICollectionViewDelegate, UICollectionViewDataSource {
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
extension MoodPubCell {
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
extension MoodPubCell: ImagePickerDelegate {
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
extension MoodPubCell {
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
