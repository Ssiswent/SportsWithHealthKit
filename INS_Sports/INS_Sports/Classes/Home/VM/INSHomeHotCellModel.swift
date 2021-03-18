//
//  INSHomeHotCellModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/10.
//

import UIKit

class INSHomeHotCellModel: TableCellModelInterface {
}

extension INSHomeHotCellModel: TableCellProvider {
    func dequeueReusableCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as INSHomeHotCell
        return cell
    }
}
