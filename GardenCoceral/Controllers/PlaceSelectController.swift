//
//  PlaceSelectController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/4/16.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class PlaceSelectController: BaseViewController {

    var search: AMapSearchAPI!
    var tableView = UITableView()
    var centerAnnotationView = UIImageView()
    var mapView = MAMapView()
    var searchPoiArray: Array<AMapPOI> = Array()
    var isLocated: Bool = false
    var isMapViewRegionChangedFromTableView: Bool = false
    var selectedIndexPath: IndexPath?
    var backPlace: ((AMapPOI)->())?
    var searchController: UISearchController?
    let searchView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.zoomLevel = 17
        mapView.isShowsUserLocation = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "地点选择"
        create()
    }
}
extension PlaceSelectController: AMapSearchDelegate, MAMapViewDelegate {
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        searchPoiArray.removeAll()
        searchPoiArray.append(contentsOf: response.pois)
        tableView.reloadData()
    }
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !updatingLocation {
            return
        }
        if userLocation.location.horizontalAccuracy < 0 {
            return
        }
        if !self.isLocated {
            self.isLocated = true
            self.mapView.userTrackingMode = .follow
            self.mapView.centerCoordinate = userLocation.location.coordinate
            self.actionSearchAround(at: userLocation.location.coordinate)
        }
    }
}
extension PlaceSelectController {
    func actionSearchAround(at coordinate: CLLocationCoordinate2D) {
        self.searchReGeocode(withCoordinate: coordinate)
        self.searchPoi(withCoordinate: coordinate)
    }
    
    func searchPoi(withCoordinate coord: CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coord.latitude), longitude: CGFloat(coord.longitude))
        request.radius = 1000
        request.sortrule = 0
        self.search.aMapPOIAroundSearch(request)
    }
    
    func searchReGeocode(withCoordinate coord: CLLocationCoordinate2D) {
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coord.latitude), longitude: CGFloat(coord.longitude))
        request.requireExtension = true
        self.search.aMapReGoecodeSearch(request)
    }
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        if !self.isMapViewRegionChangedFromTableView && self.mapView.userTrackingMode == .none {
            self.actionSearchAround(at: self.mapView.centerCoordinate)
        }
        self.isMapViewRegionChangedFromTableView = false
    }
}
extension PlaceSelectController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchPoiArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "place") as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "place")
        }
        let poi = searchPoiArray[indexPath.row]
        cell?.textLabel?.text = poi.name
        cell?.detailTextLabel?.text = poi.address
        return cell!
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell? = tableView.cellForRow(at: indexPath)
        if cell != nil {
            cell!.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell? = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.selectedIndexPath = indexPath
    }
}
extension PlaceSelectController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        searchView.fadeIn()
    }
}
extension PlaceSelectController {
    func create() {
        search = AMapSearchAPI()
        search.delegate = self
        _ = mapView.then{
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.equalToSuperview()
                m.top.equalTo(0)
                m.height.equalTo(windowHeight/3+navigationBarHeight)
            })
            $0.delegate = self
        }
        _ = centerAnnotationView.then{
            mapView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerX.equalTo(mapView.snp.centerX)
                m.bottom.equalTo(mapView.snp.centerY)
                m.width.equalTo(18)
                m.height.equalTo(30)
            })
            $0.image = UIImage(named: "wateRedBlank")
        }
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.right.bottom.equalTo(0)
                m.top.equalTo(mapView.snp.bottom)
            })
            $0.rowHeight = 60
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
        }
        let rightBtn = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(confirm))
        navigationItem.rightBarButtonItem = rightBtn
        
        _ = searchView.then{
            mapView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.left.equalTo(20)
                m.right.equalTo(-20)
                m.height.equalTo(44)
            })
            $0.backgroundColor = .white
            $0.addShadow()
            let tap = UITapGestureRecognizer()
            tap.addTarget(self, action: #selector(showSearchController))
            $0.addGestureRecognizer(tap)
        }
        let searchLogo = UIImageView().then{
            searchView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.centerY.equalToSuperview()
                m.left.equalTo(20)
                m.width.height.equalTo(22)
            })
            $0.image = #imageLiteral(resourceName: "搜索")
        }
        _ = UILabel().then{
            searchView.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.left.equalTo(searchLogo.snp.right).offset(10)
                m.top.bottom.equalToSuperview()
                m.right.equalToSuperview()
            })
            $0.text = "查找地点"
            $0.textColor = UIColor(hex: "#999")
            $0.font = UIFont.systemFont(ofSize: 16)
        }
        let searchVC = PlaceSearchResultController()
        searchVC.backPlace = { poi in
            self.searchView.fadeIn()
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(poi.location.latitude), longitude: CLLocationDegrees(poi.location.longitude))
            self.mapView.userTrackingMode = .follow
            self.mapView.centerCoordinate = coordinate
            self.actionSearchAround(at: coordinate)
        }
        let searchController = UISearchController(searchResultsController: searchVC)
        searchController.delegate = self
        searchController.searchResultsUpdater = searchVC
        self.searchController = searchController
    }
    @objc func showSearchController() {
        self.present(searchController!, animated: true, completion: nil)
        searchView.fadeOut()
    }
    @objc func confirm() {
        navigationController?.popViewController()
        if let back = self.backPlace {
            back(searchPoiArray[selectedIndexPath?.row ?? 0])
        }
    }
}
