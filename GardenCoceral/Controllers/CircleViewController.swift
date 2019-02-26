//
//  CircleViewController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/3/27.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class CircleViewController: BaseViewController {

    var tableView = UITableView()
    var headView = CircleHeadView()
    var models = [
        [
            "note": "习近平指出，中朝传统友谊是两党两国老一辈领导人亲自缔造和精心培育的，是双方共同的宝贵财富。",
            "imgs":[
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522302638532&di=062eb81483f6e6c86866b0bb380972c9&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D747732650%2C3402432322%26fm%3D214%26gp%3D0.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522302638532&di=062eb81483f6e6c86866b0bb380972c9&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D747732650%2C3402432322%26fm%3D214%26gp%3D0.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522302638532&di=062eb81483f6e6c86866b0bb380972c9&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D747732650%2C3402432322%26fm%3D214%26gp%3D0.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522302638532&di=062eb81483f6e6c86866b0bb380972c9&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D747732650%2C3402432322%26fm%3D214%26gp%3D0.jpg"
            ],
            "comments": 10,
            "likes": 10,
            "expand": false,
            "likeDatas": [
                "小朱、小高、小贾、小代、小刘、小户、小赵、小魏等觉得很赞"
            ],
            "commentDatas": [
                "小朱：习大大说的真好！我们要好好学习，天天向上！"
            ],
            "date": "3-28"
        ],
        [
            "note": "习近平指出，中朝传统友谊是两党两国老一辈领导人亲自缔造和精心培育的，是双方共同的宝贵财富。",
            "imgs":[
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522302638532&di=062eb81483f6e6c86866b0bb380972c9&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D747732650%2C3402432322%26fm%3D214%26gp%3D0.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522302638532&di=062eb81483f6e6c86866b0bb380972c9&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D747732650%2C3402432322%26fm%3D214%26gp%3D0.jpg"
            ],
            "comments": 10,
            "likes": 10,
            "expand": true,
            "likeDatas": [
                "小朱、小高、小贾、小代、小刘、小户、小赵、小魏等觉得很赞"
            ],
            "commentDatas": [
                "小朱：习大大说的真好！我们要好好学习，天天向上！",
                "小朱：习大大说的真好！我们要好好学习，天天向上！"
            ],
            "date": "3-28"
        ],
        [
            "note": "习近平指出，中朝传统友谊是两党两国老一辈领导人亲自缔造和精心培育的，是双方共同的宝贵财富。",
            "imgs":[
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522302638532&di=062eb81483f6e6c86866b0bb380972c9&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D747732650%2C3402432322%26fm%3D214%26gp%3D0.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522302638532&di=062eb81483f6e6c86866b0bb380972c9&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D747732650%2C3402432322%26fm%3D214%26gp%3D0.jpg",
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1522302638532&di=062eb81483f6e6c86866b0bb380972c9&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D747732650%2C3402432322%26fm%3D214%26gp%3D0.jpg"
            ],
            "comments": 10,
            "likes": 10,
            "expand": true,
            "likeDatas": [
                "小朱、小高、小贾、小代、小刘、小户、小赵、小魏等觉得很赞"
            ],
            "commentDatas": [
                "小朱：习大大说的真好！我们要好好学习，天天向上！",
                "小朱：习大大说的真好！我们要好好学习，天天向上！",
                "小朱：习大大说的真好！我们要好好学习，天天向上！"
            ],
            "date": "3-28"
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "圈子"
        create()
    }
}
extension CircleViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var circle = models[section]
        if circle["expand"] as? Bool == false {
            return 1
        }else {
            let comments = circle["commentDatas"] as! [String]
            return comments.count + 1
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let circle = models[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as CircleHeadCell
            cell.tag = 100 + indexPath.section
            cell.setData(circle)
            cell.expandBtn.addTarget(self, action: #selector(expanding(_:)), for: .touchUpInside)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as MoodCommentCell
            let comments = circle["commentDatas"] as! [String]
            cell.setData(comments[indexPath.row - 1])
            return cell
        }
    }
}
extension CircleViewController {
    func create() {
        
        tableView = UITableView(frame: .zero, style: .grouped).then {
            $0.tableFooterView = UIView()
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(0)
            })
            
            $0.register(cellType: CircleHeadCell.self)
            $0.register(cellType: MoodCommentCell.self)
            $0.separatorStyle = .none
            $0.delegate = self
            $0.dataSource = self
            //ios11可以不用设置estimatedRowHeight？
            $0.estimatedRowHeight = 2000
            $0.tableHeaderView = headView
            
            headView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.right.equalTo(view)
            })
            
            _ = headView.mood.rx.tap.bind{
                self.publishMood()
            }
            _ = headView.activity.rx.tap.bind{
                self.publishActivity()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }
    
    func sizeHeaderToFit() {
        let headerView = tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        // 立马布局子视图
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        // 重新设置tableHeaderView
        tableView.tableHeaderView = headerView
    }
    
    @objc func expanding(_ button: UIButton) {
        let cell = button.superview?.superview as! CircleHeadCell
        var circle = models[cell.tag - 100]
        circle["expand"] = circle["expand"] as? Bool == true ? false : true
        models[cell.tag - 100] = circle
        tableView.reloadSections(IndexSet(integer: cell.tag - 100), with: .fade)
    }
    func publishMood() {
        let vc = MoodPubViewController()
        navigationController?.pushViewController(vc)
    }
    func publishActivity() {
        let vc = ActivityPubViewController()
        navigationController?.pushViewController(vc)
    }
}
