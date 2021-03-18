//
//  INSUserCollectionCell.swift
//  Futures_0921
//
//  Created by Ssiswent on 2020/9/22.
//

import UIKit

class INSUserCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var headImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var followBtn: UIButton!
    
    var isFollow: Bool = false
    var nModel: INSUserModel?
    
    var model: INSUserModel? {
        didSet {
            nModel = model
            
            if let headStr = model?.head
            {
                headImgView.sd_setImage(with: URL(string: headStr), placeholderImage: #imageLiteral(resourceName: "pic_user_default"), options: .continueInBackground, completed: nil)
            }
            nameLabel.text = model?.nickName
//            sigLabel.text = model?.signature
            judgeIfFollowed()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        headImgView.setRadius(24)
    }
    
    @IBAction func followBtnClicked(_ sender: Any) {
        if INSAccountManager.shared.isLogin {
            isFollow = !isFollow
            requestFollow()
        }else{
            SVProgressHUD.gp_showInfo(withStatus: "请先登录", delay: 1)
        }
    }
    
    @IBAction func headBtnClicked(_ sender: Any) {
        let vc = INSDynamicViewController()
        vc.userModel = nModel
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: API
extension INSUserCollectionCell
{
    func judgeIfFollowed()
    {
        weak var weakSelf = self
        let params = [
            "userId": INSAccountManager.shared.user?.id ?? "0",
            "followerId": nModel?.id ?? "0"
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
            "followerId": nModel?.id ?? 0,
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

