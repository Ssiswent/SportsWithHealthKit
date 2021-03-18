//
//  INSTraceCell.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/25/20.
//

import UIKit

class INSTraceCell: UITableViewCell, TableCellInterface {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    
    var model: TableCellModelInterface? {
        didSet {
            if let cellModel = model as? INSHistoryCellModel {
                let model = cellModel.model
                let whitespace = NSCharacterSet.whitespacesAndNewlines
                let contentStr = model?.content?.trimmingCharacters(in: whitespace)
                if contentStr!.count > 10
                {
                    titleLabel.text = contentStr?.subString(to: 10)
                }
                else
                {
                    titleLabel.text = contentStr?.subString(to: 8)
                }
                contentLabel.text = contentStr
                
                if let picStr = model?.picture {
                    contentImgView.sd_setImage(with: URL(string: picStr), completed: nil)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        contentImgView.setRadius(5)
    }
}
