//
//  ApplyListView.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/5/23.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class ApplyListView: UIView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var numOfApplysLabel: UILabel!
    
    var bassclass:ProjectDetailProjectDetailBaseClass!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    static func newInstance() -> ApplyListView {
        let view = Bundle.main.loadNibNamed("ApplyListView", owner: self, options: nil)?.last as! ApplyListView
        return view
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 58
        tableView.register(UINib.init(nibName: "ApplyListCell2", bundle: nil), forCellReuseIdentifier: "ApplyListCell2")
        numOfApplysLabel.text = "已报名的人(\(bassclass.joins?.count ?? 0))"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bassclass.joins?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
   {
        let listModel:ProjectDetailJoins = self.bassclass.joins![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyListCell2") as! ApplyListCell2
        cell.nameLabel.text = listModel.member?.name
        cell.positionLabel.text = listModel.member?.job
    if listModel.member?.job == "" {
        cell.positionLabel.text = "无"
    }
       cell.companyLabel.text = listModel.member?.companyName
    if listModel.member?.companyName == "" {
        cell.companyLabel.text = "无"
    }
        return cell
   }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   
    */

}
