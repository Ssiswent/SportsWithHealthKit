//
//  INSTalkDetailContentCell.swift
//  Futures-0814
//
//  Created by Ssiswent on 2020/8/18.
//

import UIKit
import DateToolsSwift

class INSTalkDetailContentCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentCountLabel1: UILabel!
    
    @IBOutlet weak var contentImgViewH: NSLayoutConstraint!
    @IBOutlet weak var contentImgViewT: NSLayoutConstraint!
    
    @IBOutlet weak var followBtn: UIButton!
    var nModel: INSTalkModel!
    var isFollow: Bool = false
    
    var headBlock: (() -> Void)?
    
    var model: INSTalkModel? {
        didSet {
            nModel = model
            if let headStr = model?.user!.head
            {
                headImgView.sd_setImage(with: URL(string: headStr), placeholderImage: #imageLiteral(resourceName: "pic_user_default"), options: .continueInBackground, completed: nil)
            }
            
            nameLabel.text = model?.user?.nickName
            signatureLabel.text = model?.publishTime?.getPublishTimeStr()

            let whitespace = NSCharacterSet.whitespacesAndNewlines
            let contentStr = model?.content?.trimmingCharacters(in: whitespace)
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
            
            //设置行距
            let attStr = NSMutableAttributedString(string: contentStr!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attStr.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attStr.length))
            contentLabel.attributedText = attStr;
            
            if let picStr = model?.picture {
                if picStr.count >= 1 {
                    if picStr.subString(to: 1) != "h" {
                        contentImgView.isHidden = true
                        contentImgViewH.constant = 0
                        contentImgViewT.constant = 0
                    }
                    else {
                        contentImgView.isHidden = false
                        contentImgViewH.constant = 169
                        contentImgViewT.constant = 40
                        
//                        contentImgView.sd_setImage(with: URL(string: picStr), placeholderImage: #imageLiteral(resourceName: "pic-news2"), options: .continueInBackground, completed: nil)
                        contentImgView.sd_setImage(with: URL(string: picStr), completed: nil)
                    }
                }
            }
            
            if let commentCount = model?.commentCount
            {
                commentCountLabel1.text = localizableStr("All comments") +  "（\(commentCount)）"
            }
            
            judgeIfFollowed()
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        headImgView.setRadius(19)
        contentImgView.setRadius(10)
    }
    
    @IBAction func headBtnClicked(_ sender: Any) {
        if headBlock != nil
        {
            headBlock!()
        }
    }
    
    @IBAction func followBtnClicked(_ sender: Any) {
        if INSAccountManager.shared.isLogin {
            isFollow = !isFollow
            requestFollow()
        }else{
            SVProgressHUD.gp_showInfo(withStatus: "Please login first", delay: 1)
        }
    }
}

// MARK: API
extension INSTalkDetailContentCell
{
    func judgeIfFollowed()
    {
        weak var weakSelf = self
        let params = [
            "userId": INSAccountManager.shared.user?.id ?? "0",
            "followerId": nModel?.user?.id ?? 0
        ] as [String: Any]
        SSNetwork.shared.GET(URLStr: API.ifFollowed, params: params).success { (result) in
            if let dict:[String:Any] = result as? [String:Any]{
                if dict["success"] as? Bool ?? false{
                    let isF: String = dict["data"] as? String ?? "false"
                    if isF == "true" {
                        weakSelf?.isFollow = true
                        weakSelf?.followBtn.isSelected = true
                    } else {
                        weakSelf?.isFollow = false
                        weakSelf?.followBtn.isSelected = false
                    }
                }
            }
        }.failed { (error) in}
    }
    
    func requestFollow()
    {
        weak var weakSelf = self
        var isF: String = "false"
        if isFollow {
            isF = "true"
        } else {
            isF = "false"
        }
        let params = [
            "userId": INSAccountManager.shared.userId,
            "followerId": nModel?.user?.id ?? 0,
            "isFollow": isF
        ] as [String : Any]
        SSNetwork.shared.POST(URLStr: API.followUser, params: params).success { (result) in
            if let dic:[String:Any] = result as? [String : Any]{
                if dic["success"] as? Bool ?? false{
                    weakSelf?.followBtn.isSelected = !(weakSelf?.followBtn.isSelected)!
                }
                else
                {
                    SVProgressHUD.gp_show(withStatus: dic["msg"] as? String ?? "error", delay: 2)
                }
            }
        }.failed { (error) in
            SVProgressHUD.gp_showInfo(withStatus: "Network error", delay: 1)
        }
    }
}
