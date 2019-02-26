//
//  PlaceSearchResultController.swift
//  GardenCoceral
//
//  Created by TongNa on 2018/5/9.
//  Copyright © 2018年 tongna. All rights reserved.
//

import UIKit

class PlaceSearchResultController: BaseViewController {

    var search: AMapSearchAPI!
    var tableView = UITableView()
    var searchPoiArray: Array<AMapPOI> = Array()
    var backPlace: ((AMapPOI)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        create()
    }

}
extension PlaceSearchResultController: UITableViewDelegate, UITableViewDataSource {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            if let place = self.backPlace {
                place(self.searchPoiArray[indexPath.row])
            }
        }
    }
}
extension PlaceSearchResultController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.isEmpty == false  {
            searchPoiByKeyword(searchText)
        }
    }
}
extension PlaceSearchResultController: AMapSearchDelegate {
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        searchPoiArray.removeAll()
        searchPoiArray.append(contentsOf: response.pois)
        tableView.reloadData()
    }
}
extension PlaceSearchResultController {
    func create() {
        search = AMapSearchAPI()
        search.delegate = self
        
        tableView = UITableView(frame: .zero, style: .plain).then{
            $0.backgroundColor = .white
            view.addSubview($0)
            $0.snp.makeConstraints({ (m) in
                m.top.left.right.bottom.equalTo(0)
            })
            $0.rowHeight = 60
            $0.delegate = self
            $0.dataSource = self
            $0.tableFooterView = UIView()
        }
    }
    func searchPoiByKeyword(_ key: String) {
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = key
        request.requireExtension = true
        self.search.aMapPOIKeywordsSearch(request)
    }
}
