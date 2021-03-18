//
//  INSPrivacyCell.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/28.
//

import UIKit

class INSPrivacyCell: UITableViewCell, TableCellInterface {
    
    var model: TableCellModelInterface?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
    }
}
