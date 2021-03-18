//
//  INSStadiumDetailContentCell.swift
//  SAKBallSports
//
//  Created by Flamingo on 2020/12/15.
//

import UIKit

class INSStadiumDetailContentCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var contentImgView: UIImageView!
    
    @IBOutlet weak var contentImgViewH: NSLayoutConstraint!
    @IBOutlet weak var contentImgViewT: NSLayoutConstraint!
    
    @IBOutlet weak var collectBtn: UIButton!
    var isCollected: Bool = false
    var collectedStadiums = [INSStadiumModel]()
    var stadiumModel: INSStadiumModel?
    
    var model: INSStadiumModel? {
        didSet {
            stadiumModel = model
            if let picStr = model?.image {
                if picStr.subString(to: 1) != "h" {
                    contentImgView.isHidden = true
                    contentImgViewH.constant = 0
                    contentImgViewT.constant = 0
                }
                else {
                    contentImgView.isHidden = false
                    contentImgViewH.constant = 125
                    contentImgViewT.constant = 27
                    
                    contentImgView.sd_setImage(with: URL(string: picStr), completed: nil)
                }
            }
            
            titleLabel.text = model?.title
            addressLabel.text = model?.address
            infoLabel.text = model?.address
            timeLabel.text = model?.businessTime
            phoneLabel.text = model?.number
            
            if let price = model?.prices {
                if price == "" {
                    priceLabel.text = "人均: 52元   2小时/场"
                } else {
                    priceLabel.text = price
                }
            }
            
            getCollctedStadiums()
            judgeIfIsCollected()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentImgView.setRadius(5)
    }
    
    @IBAction func collectBtnClicked(_ sender: Any) {
        isCollected = !isCollected
        if isCollected
        {
            collectBtn.isSelected = true
            archiveCollectedBook()
            SVProgressHUD.gp_showSuccess(withStatus: "收藏成功", delay: 1)
        }
        else
        {
            collectBtn.isSelected = false
            cancelCollectedBook()
            SVProgressHUD.gp_showInfo(withStatus: "取消收藏", delay: 1)
        }
    }
    
    /// 获取收藏球馆数组
    func getCollctedStadiums()
    {
        if UserDefaults.standard.object(forKey: "collctedStadiumsArray") == nil {
            let stadiums = [INSStadiumModel]()
            self.collectedStadiums = stadiums
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(stadiums) {
                UserDefaults.standard.set(data, forKey: "collctedStadiumsArray")
            }
        } else {
            let decoder = JSONDecoder()
            // swiftlint:disable force_cast
            if let data = UserDefaults.standard.object(forKey: "collctedStadiumsArray"), let stadiums = try? decoder.decode([INSStadiumModel].self, from: data as! Data)
            {
                self.collectedStadiums = stadiums
            }
            // swiftlint:enable force_cast
        }
    }
    
    /// 判断是否收藏
    func judgeIfIsCollected()
    {
        for model in collectedStadiums {
            if stadiumModel?.id == model.id
            {
                isCollected = true
                collectBtn.isSelected = true
                break
            }
        }
    }
    
    func archiveCollectedBook()
    {
        collectedStadiums.append(stadiumModel!)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(collectedStadiums) {
            UserDefaults.standard.set(data, forKey: "collctedStadiumsArray")
        }
    }
    
    func cancelCollectedBook()
    {
        var index: Int = -1
        for model in collectedStadiums {
            index += 1
            if stadiumModel?.id == model.id
            {
                collectedStadiums.remove(at: index)
                break
            }
        }
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(collectedStadiums) {
            UserDefaults.standard.set(data, forKey: "collctedStadiumsArray")
        }
    }
}
