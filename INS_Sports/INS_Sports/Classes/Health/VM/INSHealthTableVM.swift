//
//  INSHealthTableVM.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/9.
//

import UIKit

class INSHealthTableVM: BaseTableViewModel {
    
    func build() {
        let section0 = BaseTableSectionModel()
        section0.cellModels = [INSHealthHeaderCellModel()]
        self.data = [section0]
    }
    
    func setTableView() {
        
        tableView.register(INSHealthHeaderCell.self)
        
        weak var weakSelf = self
        tableView.mj_header = SSRefreshHeader.getRefreshHeader {
            NotificationCenter.default.post(Notification(name: Notification.Name("TableViewRefresh")))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                weakSelf?.tableView.mj_header.endRefreshing()
            }
        }
//        tableView.mj_footer = SSRefreshFooter.getRefreshFooter {
//            weakSelf?.pageNumber += 1
//            weakSelf?.getNewsRequest()
//        }
    }
}
