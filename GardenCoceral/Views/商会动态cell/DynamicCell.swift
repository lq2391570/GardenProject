//
//  DynamicCell.swift
//  GardenCoceral
//
//  Created by shiliuhua on 2018/3/27.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import SDWebImage
import Spring
import SKPhotoBrowser
import Kingfisher
import RxSwift

class DynamicCell: UITableViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate {
    //动态类型枚举(0为活动，1为心情)
    public enum DynamicType:Int{
        case activityType = 0
        case moodType
    }
    var dynamicType:DynamicType!
    
    @IBOutlet var robRedbacketBtn: UIButton!
    
    @IBOutlet var robRedBacketView: UIView!
    
    @IBOutlet var applyView: UIView!
    
    @IBOutlet var headImageBtn: UserBtn!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var locationBtn: UIButton!
    
    @IBOutlet var companyBtn: UIButton!
    
    @IBOutlet var contentLabel: UILabel!
    
    @IBOutlet var picView: UIView!
    
    @IBOutlet var applyBtn: UIButton!
    
    @IBOutlet var applyLabel: UILabel!
    
    @IBOutlet var zanBtn: UIButton!
    
    @IBOutlet var zanNumLabel: UILabel!
    
    @IBOutlet var messageBtn: UIButton!
    
    @IBOutlet var mesNumLabel: UILabel!
    
    @IBOutlet var picViewHeight: NSLayoutConstraint!
    
    @IBOutlet var locationView: UIView!
    
    var picNum:NSInteger!
    
    var imageNameArray:[String] = []
    
    @IBOutlet var collection: UICollectionView!
    
    @IBOutlet var collectionHeight: NSLayoutConstraint!
    
    @IBOutlet var collectionWidth: NSLayoutConstraint!
    
    @IBOutlet var collectionContainView: UIView!
    
    @IBOutlet var companyLabel: UILabel!
    
    @IBOutlet var zanImageView: SpringImageView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var bottomViewHeight: NSLayoutConstraint!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var topViewHeight: NSLayoutConstraint!
    
    @IBOutlet var shareBtn: UIButton!
    
    @IBOutlet var shareImageView: UIImageView!
    
    @IBOutlet var topOfContentLabel: NSLayoutConstraint!
    
    @IBOutlet var addressBtn: UIButton!
    
    @IBOutlet var heightOfLocationView: NSLayoutConstraint!
    
    @IBOutlet var labelWidthContant: NSLayoutConstraint!
    
    @IBOutlet weak var shareView: UIImageView!
    
    let lineSpacing:CGFloat = 10.0
    //赞的数量
    var numOfZan = 0
    var selectNum = 0
    var selectIndexPath:IndexPath!
    //刷新表格闭包
    var reflashClosure:(() -> ())?
    //点击留言按钮闭包
    var messageBtnClickClosure:((UIButton) ->())?
    //点击赞闭包
    var zanBtnClickClosure:((UIButton) ->())?
    //点击分享闭包
    var shareClickClosure:(() ->())?
    //点击抢红包闭包
    var robHotBacketClickClosure:((UIButton) -> ())?
    //屏蔽按钮点击
    var shieldBtnClickClosure:((UIButton) -> ())?
    
    
    var currentAddress: String?
    var currentLat: Double?
    var currentLon: Double?
    let disposeBag = DisposeBag()

    func photoBrowser(_ browser: SDPhotoBrowser!, placeholderImageFor index: Int) -> UIImage! {
   
        return UIImage.init(named: "koala-walk-1@2x")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let layout = UICollectionViewLeftAlignedLayout()
        self.collection.collectionViewLayout = layout
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.register(UINib.init(nibName: "DynamicCollectionCell", bundle: nil), forCellWithReuseIdentifier: "DynamicCollectionCell")
        self.collection.register(UINib.init(nibName: "DynamicOneCollectionCell", bundle: nil), forCellWithReuseIdentifier: "DynamicOneCollectionCell")
        self.collection.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        self.labelWidthContant.constant = windowWidth - 12 - 40 - 17 - 44
        addressBtn.rx.tap.bind {
            if let lon = self.currentLon, let lat = self.currentLat {
                let vc = MapDisplayController()
                vc.lat = lat
                vc.lon = lon
                vc.address = self.currentAddress ?? ""
            self.parentViewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }.disposed(by: disposeBag)
        // self.layoutIfNeeded()
        self.selectionStyle = .none
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(shareClick))
        shareView.addGestureRecognizer(tap)
        shareView.isUserInteractionEnabled = true
    }
    @objc func shareClick() {
        if let share = shareClickClosure {
            share()
        }
    }
    func confingerCell3(with vm:MyActivityRespertable) -> Void {
        headImageBtn.userId = vm.userId
        robRedBacketView.isHidden = vm.robRedBacketViewIsHidden
        applyView.isHidden = vm.applyViewIsHidden
        contentLabel.attributedText = vm.contentStr
        applyLabel.text = vm.applyStr
        nameLabel.text = vm.nameStr
        headImageBtn.sd_setBackgroundImage(with: NSURL.init(string: vm.headImageStr) as URL?, for: UIControlState.normal, placeholderImage: UIImage.init(named: "头像"), options: SDWebImageOptions.retryFailed, completed: nil)
        companyLabel.text = vm.companyStr
        mesNumLabel.text = vm.mesNumStr
        zanNumLabel.text = vm.zanNumStr
        numOfZan = vm.numOfZan
        locationView.isHidden = vm.locationViewIsHidden
        heightOfLocationView.constant = vm.heightOfLocationView
        addressBtn.setTitle(vm.addressStr, for: .normal)
        currentLat = vm.currentLat
        currentLon = vm.currentLon
        imageNameArray = vm.imageNameArray
        collectionHeight.constant = vm.heightOfCollection
        collectionWidth.constant = vm.widthOfCollection
        zanImageView.image = UIImage.init(named: vm.zanImageStr)
        zanImageView.image?.accessibilityIdentifier = vm.zanImageStr
        self.collection.reloadData()
        self.collection.reloadInputViews()
    }
    //圈子
    func confingerMyCircleCell(with vm:MyCircleRespertable2) -> Void {
        headImageBtn.userId = vm.userId
        robRedBacketView.isHidden = vm.robRedBacketViewIsHidden
        applyView.isHidden = vm.applyViewIsHidden
        if vm.catalog == 0 {
            contentLabel.attributedText = vm.contentStr
        }else{
            contentLabel.text = vm.contentStrWithMood
        }
        applyLabel.text = vm.applyStr
        locationView.isHidden = vm.locationViewIsHidden
        heightOfLocationView.constant = vm.heightOfLocationView
        addressBtn.setTitle(vm.addressStr, for: .normal)
        currentLat = vm.currentLat
        currentLon = vm.currentLon
        currentAddress = vm.currentAddressStr
        numOfZan = vm.numOfZan
        nameLabel.text = vm.nameStr
        headImageBtn.sd_setBackgroundImage(with: NSURL.init(string: vm.listmodelHeadImageStr) as URL?, for: UIControlState.normal, placeholderImage: UIImage.init(named: "头像"), options: SDWebImageOptions.retryFailed, completed: nil)
        companyLabel.text = vm.listModelCompanyStr
        mesNumLabel.text = vm.listModelMesNumStr
        zanNumLabel.text = vm.listModelZanNumStr
        zanImageView.image = UIImage.init(named: vm.zanImageViewStr)
        zanImageView.image?.accessibilityIdentifier = vm.zanImageViewStr
        imageNameArray = vm.imageNameArray
        collectionWidth.constant = vm.widthOfCollection
        collectionHeight.constant = vm.heightOfCollection
        collection.height =  collectionHeight.constant
        dateLabel.isHidden = vm.dataLabelIsHidden
        topViewHeight.constant = vm.topViewHeight
        topOfContentLabel.constant = vm.topOfContentLabel
        topView.isHidden = vm.topViewIsHidden
        dateLabel.text = vm.dateStr
        shareBtn.isHidden = vm.shareBtnIsHidden
        shareImageView.isHidden = vm.shareImageViewIsHidden
        self.collection.reloadData()
        self.collection.reloadInputViews()
    }
    func configerDynamicDetailCell(with vm:DynamicDetailRespertable) -> Void {
        headImageBtn.userId = vm.userId
        robRedBacketView.isHidden = vm.robRedBacketViewIsHidden
        applyView.isHidden = vm.applyViewIsHidden
        if vm.catalog == 0 {
            contentLabel.attributedText = vm.contentStr
        }else{
            contentLabel.text = vm.contentStrWithMood
        }
        applyLabel.text = vm.applyStr
        locationView.isHidden = vm.locationViewIsHidden
        heightOfLocationView.constant = vm.heightOfLocationView
        addressBtn.setTitle(vm.addressStr, for: .normal)
        currentLat = vm.currentLat
        currentLon = vm.currentLon
        currentAddress = vm.currentAddressStr
        numOfZan = vm.numOfZan
        nameLabel.text = vm.nameStr
        headImageBtn.sd_setBackgroundImage(with: NSURL.init(string: vm.listmodelHeadImageStr) as URL?, for: UIControlState.normal, placeholderImage: UIImage.init(named: "头像"), options: SDWebImageOptions.retryFailed, completed: nil)
        companyLabel.text = vm.listModelCompanyStr
        mesNumLabel.text = vm.listModelMesNumStr
        zanNumLabel.text = vm.listModelZanNumStr
        bottomView.isHidden = vm.bottomViewIsHidden
        bottomViewHeight.constant = vm.bottomViewHeight
        imageNameArray = vm.imageNameArray
    }
    //首页
    func confingerFirstVCCell(with vm:FirstVCRespertable) -> Void {
        headImageBtn.userId = vm.userId
        robRedBacketView.isHidden = vm.robRedBacketViewIsHidden
        applyView.isHidden = vm.applyViewIsHidden
        if vm.catalog == 0 {
            contentLabel.attributedText = vm.contentStr
        }else{
            contentLabel.text = vm.contentStrWithMood
        }
        applyLabel.text = vm.applyStr
        locationView.isHidden = vm.locationViewIsHidden
        heightOfLocationView.constant = vm.heightOfLocationView
        addressBtn.setTitle(vm.addressStr, for: .normal)
        currentLat = vm.currentLat
        currentLon = vm.currentLon
        currentAddress = vm.currentAddressStr
        numOfZan = vm.numOfZan
        nameLabel.text = vm.nameStr
        headImageBtn.sd_setBackgroundImage(with: NSURL.init(string: vm.listmodelHeadImageStr) as URL?, for: UIControlState.normal, placeholderImage: UIImage.init(named: "头像"), options: SDWebImageOptions.retryFailed, completed: nil)
        companyLabel.text = vm.listModelCompanyStr
        mesNumLabel.text = vm.listModelMesNumStr
        zanNumLabel.text = vm.listModelZanNumStr
        zanImageView.image = UIImage.init(named: vm.zanImageViewStr)
        zanImageView.image?.accessibilityIdentifier = vm.zanImageViewStr
        imageNameArray = vm.imageNameArray
        collectionWidth.constant = vm.widthOfCollection
        collectionHeight.constant = vm.heightOfCollection
        collection.height =  collectionHeight.constant
     
        self.collection.reloadData()
        self.collection.reloadInputViews()
    }
    
    @IBAction func messageBtnClick(_ sender: UIButton) {
        if messageBtnClickClosure != nil {
            messageBtnClickClosure!(sender)
        }
    }
    @IBAction func zanBtnClick(_ sender: SpringButton) {
       zanImageView.animation = "pop"
       zanImageView.animate()
        if zanBtnClickClosure != nil {
            zanBtnClickClosure!(sender)
        }
    }
    @IBAction func robRedbacketBtnClick(_ sender: UIButton) {
        if robHotBacketClickClosure != nil {
            robHotBacketClickClosure!(sender)
        }
        
    }
    
    @IBAction func shieldBtnClick(_ sender: UIButton) {
        if let shieldBtnClickClosure = shieldBtnClickClosure{
            shieldBtnClickClosure(sender)
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if imageNameArray.count == 1 {
            return CGSize.init(width: 150, height: 150)
        }
        return CGSize.init(width: 80, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize.init(width: collectionView.frame.size.width, height: 5)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0{
            return imageNameArray.count >= 3 ? 3:imageNameArray.count
        }else if section == 1 {
            return imageNameArray.count >= 6 ? 3:imageNameArray.count - 3
        }else if section == 2 {
            return imageNameArray.count == 9 ? 3:imageNameArray.count - 6
        }
        return 0
         
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if imageNameArray.count != 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DynamicCollectionCell", for: indexPath) as! DynamicCollectionCell
          
           cell.imageView.sd_setImage(with: URL.init(string: imageNameArray[indexPath.section*3 + indexPath.row]), placeholderImage: UIImage.init(named: "加载图片"), options: SDWebImageOptions.retryFailed, completed: nil)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DynamicOneCollectionCell", for: indexPath) as! DynamicOneCollectionCell
            cell.imageView.sd_setImage(with: URL.init(string: imageNameArray[indexPath.section*3 + indexPath.row]), placeholderImage: UIImage.init(named: "加载图片"), options: SDWebImageOptions.retryFailed, completed: nil)
            return cell
        }
       
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return imageNameArray.count / 3 + 1
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
            if imageNameArray.count == 1 {
                collectionHeight.constant = 150
                collectionWidth.constant = 150
            }else if imageNameArray.count == 0 {
                 collectionHeight.constant = 0
            }else{
                collectionHeight.constant = (CGFloat)(imageNameArray.count / 4 + 1) * 85.0
                collectionWidth.constant = 255
            }
        print("collectionHeigh = %f",collectionHeight.constant)
       self.labelWidthContant.constant = windowWidth - 12 - 40 - 17 - 44
        self.collection.height = collectionHeight.constant
        self.collection.reloadData()
        self.collection.reloadInputViews()
        
        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("点击了 %d section %d row",indexPath.section,indexPath.row)
       if imageNameArray.count != 1 {
     let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionCell
        var photoArray:[SKPhoto] = []
        let originImage = cell.imageView.image // some image for baseImage
//        let photo = SKPhoto.photoWithImage(originImage!)
        for index in 0..<imageNameArray.count {
            let photoUrlStr = imageNameArray[index]
            let photo = SKPhoto.photoWithImageURL(photoUrlStr, holder: UIImage.init(named: "加载图片"))
            photoArray.append(photo)
        }
        
        let browser = SKPhotoBrowser(originImage: originImage!, photos: photoArray, animatedFromView: cell)
        browser.initializePageIndex(indexPath.section*3 + indexPath.row)
        parentViewController?.present(browser, animated: true, completion: nil)
       }else{
        let cell = collectionView.cellForItem(at: indexPath) as! DynamicOneCollectionCell
        let originImage = cell.imageView.image // some image for baseImage
        let photo = SKPhoto.photoWithImage(originImage!)
        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: [photo], animatedFromView: cell)
        browser.initializePageIndex(indexPath.row)
        parentViewController?.present(browser, animated: true, completion: nil)
       }
    }
    
}
