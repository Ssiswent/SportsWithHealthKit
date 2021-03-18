//
//  INSMineCollectionCell.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/12.
//

import UIKit

class INSMineCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    var rowIndex: Int? {
        didSet {
            var imgName: String = "pic_collection"
            var itemName: String = "收藏"
            switch rowIndex {
            case 0:
                imgName = "pic_collection"
                itemName = "我的收藏"
            case 1:
                imgName = "pic_trace"
                itemName = "浏览足迹"
            case 2:
                imgName = "pic_feedback"
                itemName = "帮助反馈"
            case 3:
                imgName = "pic_about"
                itemName = "关于我们"
            case 4:
                imgName = "pic_privacy"
                itemName = "隐私政策"
            case 5:
                imgName = "pic_cache"
                itemName = "清理缓存"
            default:
                break
            }
            itemImgView.image = UIImage(named: imgName)
            itemNameLabel.text = itemName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
    }

}
