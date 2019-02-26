//
//  MapDisplayController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/27.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit
import MapKit

class MapDisplayController: BaseViewController {

    var lat: Double?
    var lon: Double?
    var name: String?
    var address: String?
    var mapView = MAMapView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.isNavigationBarHidden = false
        }
        mapView.zoomLevel = 17
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "位置"
        create()
    }

}
extension MapDisplayController: MAMapViewDelegate {
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            let rightView = UIButton(type: .detailDisclosure)
            rightView.imageForNormal = #imageLiteral(resourceName: "map-nav")
            rightView.rx.tap.bind {
                if let lat = self.lat, let lon = self.lon {
                    self.mapNav(lat, lon: lon)
                }
            }.disposed(by: disposeBag)
            annotationView!.rightCalloutAccessoryView = rightView
            annotationView!.pinColor = .red
            
            return annotationView!
        }
        
        return nil
    }
}
extension MapDisplayController {
    func create() {
        _ = mapView.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalToSuperview()
                m.top.equalTo(0)
            })
            $0.delegate = self
            if let lat = self.lat, let lon = self.lon {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                $0.centerCoordinate = coordinate
                let pointAnnotation = MAPointAnnotation()
                pointAnnotation.coordinate = coordinate
                pointAnnotation.title = self.name ?? "正在获取中..."
                pointAnnotation.subtitle = self.address ?? "正在获取中..."
                $0.addAnnotation(pointAnnotation)
            }
        }
    }
    func mapNav(_ lat: Double, lon: Double) {
        let alertController = UIAlertController(title: "选择导航地图", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        //系统自带地图，内核高德地图，无需判断是否安装
        let appleAction = UIAlertAction(title: "自带地图", style: .default){ (action) in
            let currentLocation = MKMapItem.forCurrentLocation()
            let toLocation = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), addressDictionary: nil))
            MKMapItem.openMaps(with: [currentLocation, toLocation],
                               launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                               MKLaunchOptionsShowsTrafficKey:true])
        }
        //百度地图
        if UIApplication.shared.canOpenURL(URL(string: "baidumap://")!) {//判断是否安装了地图
            let baiduAction = UIAlertAction(title: "百度地图", style: .default){ (action) in
                //注意：origin={{我的位置}}不要变；目的地随便写
                let urlString = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(lat),\(lon)|name=目的地&mode=driving&coord_type=gcj02"
                let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                UIApplication.shared.openURL(URL(string: escapedString!)!)
            }
            alertController.addAction(baiduAction)
        }
        //高德地图
        if UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) {
            let gaodeAction = UIAlertAction(title: "高德地图", style: .default){ (action) in
                let urlString = "iosamap://nav?sourceApplication=GardenCoceral&backScheme=GardenCoceral&lat=\(lat)&lon=\(lon)&dev=0&style=2"
                let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                UIApplication.shared.openURL(URL(string: escapedString!)!)
            }
            alertController.addAction(gaodeAction)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(appleAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
}
