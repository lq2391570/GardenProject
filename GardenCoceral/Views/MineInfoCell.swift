//
//  MineInfoCell.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import Reusable
import ImagePicker
import SKPhotoBrowser
import RxSwift

class MineInfoCell: UITableViewCell, Reusable {

    let disposeBag = DisposeBag()
    var avatar = UIImageView()
    var name = UILabel()
    var job = UILabel()
    var status = UIButton()
    var model: UserModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _ = avatar.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.width.height.equalTo(80)
                m.left.equalTo(15)
                m.top.equalTo(25)
                m.bottom.equalTo(-25)
            })
            $0.cornerRadius = 40
            let tap = UITapGestureRecognizer()
            tap.addTarget(self, action: #selector(alertPicker))
            $0.addGestureRecognizer(tap)
            $0.isUserInteractionEnabled = true
            $0.contentMode = .scaleAspectFill
        }
        
        _ = status.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.equalTo(avatar.snp.top).inset(12)
                m.right.equalTo(-15)
                m.width.equalTo(55)
                m.height.equalTo(22)
            })
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            $0.addTarget(self, action: #selector(apply), for: .touchUpInside)
            $0.setTitleColor(UIColor.white, for: .normal)
        }
        _ = name.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(avatar.snp.right).offset(15)
                m.top.equalTo(avatar.snp.top).inset(12)
                m.height.greaterThanOrEqualTo(22)
                m.right.equalTo(status.snp.left).inset(10)
            })
            name.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
            name.textColor = UIColor.white
        }
        
        _ = job.then{
            contentView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(name)
                m.top.equalTo(name.snp.bottom).offset(10)
                m.height.greaterThanOrEqualTo(21)
                m.right.equalTo(name)
            })
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(hexString: "#666")
            $0.textColor = UIColor.white
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MineInfoCell {
    func setData(_ model: UserModel) {
        self.model = model
        avatar.kf.setImage(with: URL(string: model.avatar ?? ""), placeholder: #imageLiteral(resourceName: "加载图片"))
        name.text = model.name ?? "忘了起名字了"
        job.text = model.job ?? "无可奉告"
        if model.catalog == 0 {
            status.backgroundColor = UIColor.init(red: 172/255.0, green: 42/255.0, blue: 51/255.0, alpha: 1)
            status.titleForNormal = "已入会"
        //    status.titleColorForNormal = UIColor.white
             status.titleColorForNormal = UIColor.white
            status.backgroundColor = navBarColor
            status.layer.borderWidth = 1
            status.layer.borderColor = UIColor.white.cgColor
        }else {
            status.backgroundColor = .white
            status.borderColor = UIColor.white
            status.borderWidth = 1
            if model.catalog == 1 {
                status.titleForNormal = "未入会"
            }else if model.catalog == 2 {
                status.titleForNormal = "待审核"
            }else if model.catalog == 3 {
                status.titleForNormal = "已过期"
            }
           // status.titleColorForNormal = themeColor
            status.titleColorForNormal = UIColor.white
        }
    }
    @objc func apply() {
        if model?.catalog == 0 {
            let vc = CommerceStateController()
            parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = RegisterController()
            parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func alertPicker() {
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
extension MineInfoCell: ImagePickerDelegate {
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
                MyService.shareInstance.uploadFile(fullPath).subscribe(onSuccess: { (m) in
                    if m.code == 0 {
                        MyService.shareInstance.updateAvatar("1", userToken: userToken(), avatar: m.url ?? "").subscribe(onSuccess: { (model) in
                            if model.code == 0 {
                                self.avatar.kf.setImage(with: URL(string: model.avatar ?? ""), placeholder: #imageLiteral(resourceName: "加载图片"))
                            }
                        }).disposed(by: self.disposeBag)
                    }
                }).disposed(by: disposeBag)
            } catch {
                Log(error)
            }
        }
        avatar.image = images[0]
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
