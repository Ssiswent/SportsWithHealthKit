//
//  INSHuDongTalkCellModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/11.
//

import UIKit

class INSHuDongTalkCellModel: TableCellModelInterface {
    var model: INSTalkModel!
}

extension INSHuDongTalkCellModel: TableCellProvider {
    func dequeueReusableCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as INSHuDongTalkCell
        return cell
    }
}
