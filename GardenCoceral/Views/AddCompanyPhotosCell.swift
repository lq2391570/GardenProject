//
//  AddCompanyPhotosCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/5/25.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import ImagePicker
import SKPhotoBrowser

class AddCompanyPhotosCell: UITableViewCell, Reusable {

    var logo = UIImageView()
    var license = UIImageView()
    var backLogo: ((String)->())?
    var backLicense: ((String)->())?
    var select: Int?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = logo.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(25)
                m.left.equalTo(60)
                m.right.equalTo(-60)
                m.height.equalTo(logo.snp.width).dividedBy(1.67)
            })
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(uploadLogo))
            $0.addGestureRecognizer(tap)
            $0.isUserInteractionEnabled = true
        }
        _ = license.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(logo.snp.bottom).offset(25)
                m.left.right.height.equalTo(logo)
                m.bottom.equalTo(-25)
            })
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(uploadLicense))
            $0.addGestureRecognizer(tap)
            $0.isUserInteractionEnabled = true
        }
        setData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension AddCompanyPhotosCell {
    func setData() {
        logo.image = #imageLiteral(resourceName: "member-upload")
        license.image = #imageLiteral(resourceName: "member-upload")
    }
    @objc func uploadLogo() {
        select = 1
        alertPicker()
    }
    @objc func uploadLicense() {
        select = 2
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
extension AddCompanyPhotosCell: ImagePickerDelegate {
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
                if select == 1 {
                    if let backLogo = self.backLogo { backLogo(fullPath) }
                }else {
                    if let backLicense = self.backLicense { backLicense(fullPath) }
                }
            } catch {
                Log(error)
            }
        }
        if select == 1 {
            logo.image = images[0]
        }else {
            license.image = images[0]
        }
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
