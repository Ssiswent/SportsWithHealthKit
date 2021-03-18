//
//  INSStadiumDetailRecommendCollectionViewCell.swift
//  SAKBallSports
//
//  Created by Flamingo on 2020/12/15.
//

import UIKit

class INSStadiumDetailRecommendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    
    var model: INSStadiumModel? {
        didSet {
            titleLabel.text = model?.title
            if let picStr = model?.image {
                contentImgView.sd_setImage(with: URL(string: picStr), completed: nil)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentImgView.setRadius(5)
        backgroundColor = .clear
    }

}
