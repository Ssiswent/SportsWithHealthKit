//
//  INSHomeStadiumCellModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/10.
//

import UIKit

class INSHomeStadiumCellModel: TableCellModelInterface {
    var model: INSStadiumModel!
}

extension INSHomeStadiumCellModel: TableCellProvider {
    func dequeueReusableCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as INSHomeStadiumCell
        return cell
    }
}
