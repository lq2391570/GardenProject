//
//  CircleFirstCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/4/13.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SVProgressHUD
//import Reusable
class CircleFirstCell: UITableViewCell {

    @IBOutlet var headImageView: UIImageView!
    
    @IBOutlet var nameAndPositionLabel: UILabel!
    
    @IBOutlet var companyLabel: UILabel!
    
    @IBOutlet var phoneNumLabel: UILabel!
    
    @IBOutlet var locationBtn: UIButton!
    
    @IBOutlet var LocationNameLabel: UILabel!
    
    @IBOutlet var locationImageView: UIImageView!
    
    @IBOutlet var phoneBtn: UIButton!
    
    var memModel:ActivityMember!
    
    var phoneBtnClickClosure:((UIButton) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        phoneBtn.borderColor = themeColor
        phoneBtn.borderWidth = 1
        phoneBtn.setTitleColor(themeColor, for: .normal)
    }
    @IBAction func phoneBtnClick(_ sender: UIButton) {
       
        let alertVC:UIAlertController = UIAlertController.init(title: "是否拨打电话", message: "", preferredStyle: .alert)
        let action1 = UIAlertAction.init(title: "确定", style: .default, handler: { (action) in
            //拨打电话
            judgeUserState { (state) in
                if state == 4 {
                    //未登录
                    SVProgressHUD.showInfo(withStatus: "请登录")
                }else{
                    if self.memModel.phone == nil {
                        SVProgressHUD.showInfo(withStatus: "此用户暂无电话")
                    }else{
                        UIApplication.shared.openURL(URL.init(string: "tel://\(self.memModel.phone!)")!)
                    }
                }
            }
            
        })
        let action2 = UIAlertAction.init(title: "取消", style: .cancel, handler: { (action) in
            
        })
        alertVC.addAction(action1)
        alertVC.addAction(action2)
        parentViewController?.present(alertVC, animated: true, completion: nil)
        
    }
    func configerCell(with vm:MyCircleRespertable) -> Void {
        self.memModel = vm.memModel
        headImageView.sd_setImage(with: URL.init(string: vm.headImageStr), placeholderImage: UIImage.init(named: "头像"), options: .retryFailed, completed: nil)
        nameAndPositionLabel.attributedText = vm.nameAndPositionStr
        companyLabel.text = vm.companyStr
        phoneNumLabel.text = vm.phoneNumStr
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
