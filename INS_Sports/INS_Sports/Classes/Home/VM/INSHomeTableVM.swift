//
//  INSHomeTableVM.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/10.
//

import UIKit

class INSHomeTableVM: BaseTableViewModel {
    
    var stadiumsArray = [INSStadiumModel]()
    var stadiumCellModels = [INSHomeStadiumCellModel]()
    
    func build() {
        let section0 = BaseTableSectionModel()
        section0.cellModels = [INSHomeHotCellModel()]
        let secHeader0 = INSHomeSectionHeaderView()
        secHeader0.leftLabel.text = "热门球馆"
        section0.header = secHeader0
        section0.headerHeight = 40
        
        let section1 = BaseTableSectionModel()
        section1.cellModels = stadiumCellModels
        let secHeader1 = INSHomeSectionHeaderView()
        secHeader1.leftLabel.text = "专项球馆"
        section1.header = secHeader1
        section1.headerHeight = 40
        
        self.data = [section0, section1]
    }
    
    func setTableView() {
        pageNumber = 2
        
        let homeHeaderView = INSHomeHeaderView(frame: CGRect(x: 0, y: 0, width: KScreenWidth, height: 120))
        tableView.tableHeaderView = homeHeaderView
        
        tableView.register(INSHomeHotCell.self)
        tableView.register(INSHomeStadiumCell.self)
        
        weak var weakSelf = self
        tableView.mj_header = SSRefreshHeader.getRefreshHeader {
            weakSelf?.pageNumber = 2
            weakSelf?.getStadiumsRequest()
            NotificationCenter.default.post(Notification(name: Notification.Name("TableViewRefresh")))
        }
        tableView.mj_footer = SSRefreshFooter.getRefreshFooter {
            weakSelf?.pageNumber += 1
            weakSelf?.getStadiumsRequest()
        }
        
        cellDidSelected = { (indexPath, cellModel) in
            if indexPath.section == 1 {
                let vc = INSStaduimDetailsViewController()
                vc.stadiumModel = weakSelf?.stadiumsArray[indexPath.row]
                currentViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 529
        } else {
            return 130
        }
    }
}

// MARK: Network request
extension INSHomeTableVM
{
    func getStadiumsRequest() {
        weak var weakSelf = self
        var params = [String:Any]()
        params["pageNum"] = pageNumber
        params["pageSize"] = 6
        SSNetwork.shared.GET(URLStr: API.getStadiums, params: params).success { (result) in
            if let dict = result as? [String: Any] {
                if let arr = INSStadiumModel.mj_objectArray(withKeyValuesArray: (dict["data"] as? [String: Any])?["list"]) as? [INSStadiumModel] {
                    if weakSelf?.pageNumber == 2 {
                        weakSelf?.stadiumsArray = arr
                    } else {
                        if arr.count > 0 {
                            weakSelf?.stadiumsArray += arr
                        } else {
                            weakSelf?.pageNumber -= 1
                        }
                    }
                }
            }
            var temp = [INSHomeStadiumCellModel]()
            for model in self.stadiumsArray {
                let cellModel = INSHomeStadiumCellModel()
                cellModel.model = model
                temp.append(cellModel)
            }
            weakSelf?.stadiumCellModels = temp
            SVProgressHUD.dismiss()
            weakSelf?.build()
            weakSelf?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
            if let cells = weakSelf?.tableView.visibleCells(in: 1)
            {
                UIView.animate(views: cells, animations: weakSelf!.cellAnim)
            }
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: localizableStr("Network error"), delay: 1)
            SVProgressHUD.dismiss()
            weakSelf?.build()
            weakSelf?.reload()
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }
}
