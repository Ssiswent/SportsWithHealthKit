//
//  INSHuDongTalkCell.swift
//  HaveYouReadToday
//
//  Created by Flamingo on 2020/12/12.
//

import UIKit

class INSHuDongTalkCell: UITableViewCell, TableCellInterface {
    
    static let reuseID = "INSHuDongTalkCell"
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var headImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var contentImgViewH: NSLayoutConstraint!
    @IBOutlet weak var contentImgViewT:NSLayoutConstraint!
    
    var userModel: INSUserModel?
    
    var model: TableCellModelInterface? {
        didSet {
            if let cellModel = model as? INSHuDongTalkCellModel {
                let talkModel: INSTalkModel = cellModel.model
                userModel = talkModel.user
                
                headImgView.sd_setImage(with: URL(string: (talkModel.user?.head)!), placeholderImage: #imageLiteral(resourceName: "pic_user_default"), options: .continueInBackground, completed: nil)
                
                nameLabel.text = talkModel.user?.nickName
                timeLabel.text = talkModel.publishTime?.getPublishTimeStr()
                
                let contentStr = talkModel.content?.trimmingCharacters(in: .whitespacesAndNewlines)
                contentLabel.text = contentStr
                //设置行距
                let attStr = NSMutableAttributedString(string: contentStr!)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 5
                attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attStr.length))
                contentLabel.attributedText = attStr;
                
                if contentStr!.count >= 10
                {
                    titleLabel.text = contentStr?.subString(to: 10)
                }
                else if contentStr!.count >= 8 && contentStr!.count < 10
                {
                    titleLabel.text = contentStr?.subString(to: 8)
                }
                else if contentStr!.count >= 6 && contentStr!.count < 8
                {
                    titleLabel.text = contentStr?.subString(to: 6)
                }
                else
                {
                    titleLabel.text = ""
                }
                
                if let picStr = talkModel.picture {
                    if picStr.count >= 1 {
                        if picStr.subString(to: 1) != "h" {
                            contentImgView.isHidden = true
                            contentImgViewH.constant = 0
                            contentImgViewT.constant = 0
                        } else {
                            contentImgView.isHidden = false
                            contentImgViewH.constant = ((KScreenWidth - 165) * 4)/3
                            contentImgViewT.constant = 30
                            
                            contentImgView.sd_setImage(with: URL(string: picStr), placeholderImage: #imageLiteral(resourceName: "talk_default"), options: .continueInBackground, completed: nil)
                        }
                    }
                }
                
                let count: Int = Int(arc4random() % 150) + 33
                countLabel.text = "总共\(count)人浏览过"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        headImgView.setRadius(25)
        contentImgView.setRadius(10)
    }
    
    @IBAction func headBtnClicked(_ sender: Any) {
        let vc = INSDynamicViewController()
        vc.userModel = userModel
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
