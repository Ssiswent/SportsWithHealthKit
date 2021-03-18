//
//  INSFindUserCellModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/11.
//

import UIKit

class INSFindUserCellModel: TableCellModelInterface {
}

extension INSFindUserCellModel: TableCellProvider {
    func dequeueReusableCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as INSFindUserCell
        return cell
    }
}
