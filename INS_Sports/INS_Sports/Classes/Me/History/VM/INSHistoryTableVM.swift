//
//  INSHistoryTableVM.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/29.
//

import UIKit
import ViewAnimator

class INSHistoryTableVM: BaseTableViewModel {
    
    var navItemEnable: Bool = false
    
    var cellModels = [INSHistoryCellModel]()
    
    func build() {
        let section = BaseTableSectionModel()
        section.cellModels = cellModels
        self.data = [section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.viewDisplayImage(withMsg: "暂无记录", lottieStr: "lottie_empty", action: {}, ifNecessaryForRowCount: cellModels.count)
        return cellModels.count
//        guard let sec = data?[section], let cells = sec.cellModels else {
//            return 0
//        }
//        return cells.count
    }
}

extension INSHistoryTableVM
{
    func cellModelsWithFootArr(arr: [INSTalkModel]) ->  [INSHistoryCellModel]{
        var cellModels = [INSHistoryCellModel]()
        for model in arr {
            let cellModel = INSHistoryCellModel()
            cellModel.model = model
            cellModels.append(cellModel)
        }
        return cellModels
    }
    
    func getFootArr() {
        var footArr = [INSTalkModel]()
        let decoder = JSONDecoder()
        // swiftlint:disable force_cast
        if let data = UserDefaults.standard.object(forKey: "VIEWEDTALK"), let footArray = try? decoder.decode([INSTalkModel].self, from: data as! Data)
        // swiftlint:enable force_cast
        {
            footArr = footArray
            cellModels = cellModelsWithFootArr(arr: footArr)
            build()
            tableView?.reloadData()
            if let cells = tableView?.visibleCells(in: 0)
            {
                UIView.animate(views: cells, animations: cellAnim)
            }
        }
        
        if footArr.count > 0
        {
            navItemEnable = true
            NotificationCenter.default.post(name: Notification.Name("ChangeNavItem"), object: nil)
        }
    }
    
    @objc func clearFootArr()
    {
        let cleanFootArray = [INSTalkModel]()
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(cleanFootArray) {
            UserDefaults.standard.set(data, forKey: "VIEWEDTALK")
        }
        cellModels = cellModelsWithFootArr(arr: cleanFootArray)
        build()
        tableView?.reloadSections(IndexSet(integer: 0), with: .left)
        navItemEnable = false
        NotificationCenter.default.post(name: Notification.Name("ChangeNavItem"), object: nil)
    }
}
