//
//  INSHealthHeaderCellModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/9.
//

import UIKit

class INSHealthHeaderCellModel: TableCellModelInterface {
}

extension INSHealthHeaderCellModel: TableCellProvider {
    func dequeueReusableCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as INSHealthHeaderCell
        return cell
    }
}
