//
//  INSPrivacyCellModel.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/28.
//

import UIKit

class INSPrivacyCellModel: TableCellModelInterface {

}

extension INSPrivacyCellModel: TableCellProvider {
    func dequeueReusableCell(fromTableView tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(indexPath: indexPath) as INSPrivacyCell
    }
}
