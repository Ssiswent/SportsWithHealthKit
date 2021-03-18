//
//  INSTalkDetailCommentCell.swift
//  Futures-0814
//
//  Created by Ssiswent on 2020/8/18.
//

import UIKit
import DateToolsSwift

class INSTalkDetailCommentCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImgView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var replyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var replyViewTop: NSLayoutConstraint!

    @IBOutlet weak var likeCountLabel: UILabel!
    
    var model: INSCommentModel? {
        didSet {
            commentLabel.text = model?.content
            if let headStr = model?.user?.head
            {
                headImgView.sd_setImage(with: URL(string: headStr), placeholderImage: #imageLiteral(resourceName: "pic_user_default"), options: .continueInBackground, completed: nil)
            }
            
            nameLabel.text = model?.user!.nickName
            
            //获取随机数
            //日期: 2 ~ 8
//            let count1: Int = Int(arc4random() % 7) + 2
//            timeLabel.text = "\(count1)天前"
            timeLabel.text = Date().format(with: "MM-dd HH:mm")
            
            //随机显示回复框
            let count2: Int = Int(arc4random()) % 2
            if count2 == 0
            {
                replyView.isHidden = true
                replyViewHeight.constant = 0
                replyViewTop.constant = 0
            }
            else
            {
                replyView.isHidden = false
                replyViewHeight.constant = 44
                replyViewTop.constant = 10
            }
            
            //点赞数: 0 ~ 9
            let count3: Int = Int(arc4random() % 10)
            likeCountLabel.text = "\(count3)"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        replyView.setRadius(5)
        headImgView.setRadius(13.5)
        commentLabel.textColor = AppGlobalThemeColor
    }
}
