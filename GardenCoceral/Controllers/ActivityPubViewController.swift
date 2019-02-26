//
//  ActivityPubViewController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/3/28.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD

class ActivityPubViewController: BaseViewController {

    var tableView = UITableView()
    var imagePaths = [String]()
    var imageUrls = [String]()
    var beginDate = Date()
    var note = ""
    var num = 0
    var poi: AMapPOI?
    var back: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "发布活动"
        create()
    }
}
extension ActivityPubViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ActivityPubCell
        cell.tableView = tableView
        cell.backImgs = { imgs in
            self.imagePaths = imgs
        }
        cell.backDate = { date in
            self.beginDate = date
        }
        cell.backNum = { num in
            self.num = num.int ?? 0
        }
        cell.backNote = { note in
            self.note = note
        }
        cell.backPoi = { poi in
            self.poi = poi
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension ActivityPubViewController {
    func create()  {
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = backColor
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            $0.register(cellType: ActivityPubCell.self)
            $0.estimatedRowHeight = 2000
            $0.delegate = self
            $0.dataSource = self
            
            let bottomView = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: 100))
            let submitBtn = UIButton(type: .custom)
            submitBtn.frame = CGRect(x: 25, y: 20, width: windowWidth-50, height: 42)
            submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            submitBtn.titleForNormal = "发布活动"
            submitBtn.titleColorForNormal = .white
            submitBtn.backgroundColor = primaryBtnColor
            submitBtn.addTarget(self, action: #selector(publish), for: .touchUpInside)
            bottomView.addSubview(submitBtn)
            $0.tableFooterView = bottomView
        }
    }
    @objc func publish() {
        imageUrls.removeAll()
        guard !note.isEmpty else {
            SVProgressHUD.showError(withStatus: "说点什么吧")
            return
        }
        SVProgressHUD.show()
        guard imagePaths.count != 0 else {
            publishActivity()
            return
        }
        for item in imagePaths {
            service.uploadFile(item).subscribe(onSuccess: { (model) in
                if model.code == 0 {
                    Log(model.url)
                    self.imageUrls.append(model.url ?? "")
                    guard self.imageUrls.count == self.imagePaths.count else {
                        return
                    }
                    self.publishActivity()
                }else {
                    Log(model.msg)
                    self.imageUrls.append("上传失败")
                    SVProgressHUD.showError(withStatus: model.msg ?? "有张图片走丢了")
                }
            }).disposed(by: disposeBag)
        }
        
    }
    func publishActivity() {
        guard let poi = self.poi else {
            SVProgressHUD.showError(withStatus: "选个地址吧")
            return
        }
        self.service.publishActivity("1", userToken: getCurrentUser().userToken ?? "", note: self.note, address: poi.name ?? "", lng: poi.location.longitude.double, lat: poi.location.latitude.double, money: 0, num: self.num, beginDate: beginDate.timeIntervalSince1970*1000, imgs: self.imageUrls).subscribe(onSuccess: { (m) in
            SVProgressHUD.dismiss()
            if m.code == 0 {
                
                //发布成功后发一个通知，首页刷新
                let notiName = Notification.Name(rawValue: "POSTACTSUCCEED")
                NotificationCenter.default.post(name: notiName, object: nil, userInfo: nil)
                
                SVProgressHUD.showSuccess(withStatus: "发起成功")
                if let back = self.back { back() }
                SVProgressHUD.dismiss(withDelay: 1, completion: {
                    self.navigationController?.popViewController()
                })
            }else {
                SVProgressHUD.showError(withStatus: m.msg ?? "发起失败")
            }
        }, onError: { error in
            SVProgressHUD.showError(withStatus: "服务器异常")
        }).disposed(by: self.disposeBag)
    }
}
