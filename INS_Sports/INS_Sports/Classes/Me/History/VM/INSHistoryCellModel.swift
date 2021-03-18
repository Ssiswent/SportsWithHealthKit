//
//  INSHistoryCellModel.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/29.
//

import UIKit

class INSHistoryCellModel: TableCellModelInterface {
    var model: INSTalkModel?
}

extension INSHistoryCellModel: TableCellProvider {
    func dequeueReusableCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(indexPath: indexPath) as INSTraceCell
    }
}
