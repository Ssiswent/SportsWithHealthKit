//
//  INSHomeHotCollectionCell.swift
//  Futures_Remix
//
//  Created by Ssiswent on 2020/9/27.
//

import UIKit

class INSHomeHotCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    
    @IBOutlet weak var collectBtn: UIButton!
    
    var isCollected: Bool = false
    
    var collectBlock: (() -> Void)?
    var cancelBlock: (() -> Void)?

    var stadiumModel: INSStadiumModel?
    
    var collectedStadiums: [INSStadiumModel]? {
        didSet {
            judgeIfIsCollected()
        }
    }
    
    var model: INSStadiumModel? {
        didSet {
            stadiumModel = model
            titleLabel.text = model?.title
            if let price = model?.prices {
                if price == "" {
                    priceLabel.text = "人均：52.0元"
                } else {
                    priceLabel.text = price
                }
            }
            
            if let picStr = model?.image {
                contentImgView.sd_setImage(with: URL(string: picStr), placeholderImage: #imageLiteral(resourceName: "stadium_default"), options: .continueInBackground, completed: nil)
            }
            
            isCollected = false
            collectBtn.isSelected = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        priceLabel.textColor = AppGlobalThemeColor
    }
    
    @IBAction func collectBtnClicked(_ sender: Any) {
        isCollected = !isCollected
        if isCollected
        {
            collectBtn.isSelected = true
            if collectBlock != nil {
                collectBlock!()
            }
            SVProgressHUD.gp_showSuccess(withStatus: "收藏成功", delay: 1)
        }
        else
        {
            collectBtn.isSelected = false
            if cancelBlock != nil {
                cancelBlock!()
            }
            SVProgressHUD.gp_showInfo(withStatus: "取消收藏", delay: 1)
        }
    }
    
    /// 判断是否收藏
    func judgeIfIsCollected()
    {
        for model in collectedStadiums! {
            if stadiumModel?.id == model.id
            {
                isCollected = true
                collectBtn.isSelected = true
                break
            }
        }
    }
}
