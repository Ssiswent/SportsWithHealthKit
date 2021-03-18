//
//  INSHomeStadiumCell.swift
//  Futures_Remix
//
//  Created by Ssiswent on 2020/9/27.
//

import UIKit

class INSHomeStadiumCell: UITableViewCell, TableCellInterface {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    
    var model: TableCellModelInterface? {
        didSet {
            if let cellModel = model as? INSHomeStadiumCellModel {
                let stadiumModel: INSStadiumModel = cellModel.model
                
                titleLabel.text = stadiumModel.title
                addressLabel.text = stadiumModel.address
                if let price = stadiumModel.prices {
                    if price == "" {
                        priceLabel.text = "人均：52元"
                    } else {
                        priceLabel.text = price
                    }
                }
                
                if let picStr = stadiumModel.image {
                    contentImgView.sd_setImage(with: URL(string: picStr), placeholderImage: #imageLiteral(resourceName: "stadium_default"), options: .continueInBackground, completed: nil)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        priceLabel.textColor = AppGlobalThemeColor
    }
}
