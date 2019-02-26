//
//  AddMemberCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/10.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import ImagePicker
import SKPhotoBrowser

class AddMemberCell: UITableViewCell, Reusable {

    var company = UILabel()
    var address = UILabel()
    var photo = UIImageView()
    var backImg: ((String)->())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = company.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.left.equalTo(25)
                m.right.equalTo(-15)
            })
            $0.textColor = UIColor(hexString: "#666")
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        
        _ = address.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(company.snp.bottom).offset(20)
                m.left.equalTo(company)
                m.right.equalTo(-15)
            })
            $0.textColor = UIColor(hexString: "#666")
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        
        _ = photo.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(address.snp.bottom).offset(35)
                m.left.equalTo(60)
                m.right.equalTo(-60)
                m.height.equalTo(photo.snp.width).dividedBy(1.67)
                m.bottom.equalToSuperview()
            })
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.image = #imageLiteral(resourceName: "member-upload")
            let tap = UITapGestureRecognizer(target: self, action: #selector(uploadFile))
            $0.addGestureRecognizer(tap)
            $0.isUserInteractionEnabled = true
        }
        setData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension AddMemberCell {
    func setData() {
        company.text = "机构名称：\("观止科技")"
        address.text = "机构地址：\("未央区凤城二路")"
    }
    @objc func uploadFile() {
        alertPicker()
    }
    func alertPicker() {
        var configuration = Configuration()
        configuration.cancelButtonTitle = "取消"
        configuration.doneButtonTitle = "完成"
        configuration.noImagesTitle = "貌似还没有图片哦！"
        configuration.recordLocation = false
        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        parentViewController?.present(imagePickerController, animated: true, completion: nil)
    }
}
extension AddMemberCell: ImagePickerDelegate {
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
        if let imgData = UIImageJPEGRepresentation(images[0], 0.1) {
            let fullPath = NSHomeDirectory() + "/Documents/\(Date().timeIntervalSince1970).jpg"
            let url = URL(fileURLWithPath: fullPath)
            do {
                try imgData.write(to: url, options: .atomic)
                Log(fullPath)
                if let backImg = self.backImg { backImg(fullPath) }
            } catch {
                Log(error)
            }
        }
        photo.image = images[0]
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
