 //
 //  INSClassifiedStadiumCell.swift
 //  SAKBallSports
 //
 //  Created by Flamingo on 2020/12/16.
 //
 
 import UIKit
 import DateToolsSwift
 
 class INSClassifiedStadiumCell: UITableViewCell {
    
    @IBOutlet weak var contentImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var lessView: UIView!
    
    @IBOutlet weak var detailsViewT: NSLayoutConstraint!
    @IBOutlet weak var detailsViewB: NSLayoutConstraint!
    @IBOutlet weak var detailsViewH: NSLayoutConstraint!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var more_titleLabel: UILabel!
    @IBOutlet weak var more_timeLabel: UILabel!
    @IBOutlet weak var more_addressLabel: UILabel!
    @IBOutlet weak var more_phoneLabel: UILabel!
    @IBOutlet weak var more_typeLabel: UILabel!
    @IBOutlet weak var more_priceLabel: UILabel!
    @IBOutlet weak var more_updateTime: UILabel!
    
    var stadiumModel: INSStadiumModel?
    
    var moreOrLessBlock: (() -> Void)?
    
    var model: INSStadiumModel? {
        didSet {
            stadiumModel = model
            
            if let picStr = model?.image {
                contentImgView.sd_setImage(with: URL(string: picStr), placeholderImage: #imageLiteral(resourceName: "stadium_default"), options: .continueInBackground, completed: nil)
            }
            titleLabel.text = model?.title
            addressLabel.text = model?.address
            if let price = model?.prices {
                if price == "" {
                    priceLabel.text = "人均：52元"
                } else {
                    priceLabel.text = price
                }
            }
            
            if let isMore = model?.isOpen {
                if isMore {
                    detailsViewH.constant = 167
                    detailsViewT.constant = 15
                    detailsViewB.constant = 22
                    more_titleLabel.text = model?.title
                    more_timeLabel.text = model?.businessTime
                    more_addressLabel.text = model?.address
                    more_phoneLabel.text = model?.number
                    more_typeLabel.text = model?.typeName
                    if let price = model?.prices {
                        if price == "" {
                            more_priceLabel.text = "人均：52元"
                        } else {
                            more_priceLabel.text = price
                        }
                    }
                    
                    if let time = model?.updateTime
                    {
                        let date = time.getDateFromTime()
                        let dateStr = date.format(with: "MM-dd")
                        more_updateTime.text = dateStr
                    }
                    
                    lessView.isHidden = false
                    moreView.isHidden = true
                    detailsView.isHidden = false
                } else {
                    detailsViewH.constant = 0
                    detailsViewT.constant = 20
                    detailsViewB.constant = 0
                    lessView.isHidden = true
                    moreView.isHidden = false
                    detailsView.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentImgView.setRadius(10)
        
        detailsView.setRadius(10)
        detailsView.setShadow(color: UIColor(hexString: "#000000", alpha: 0.11), opacity: 1, radius: 25, offset: CGSize(width: 4, height: 4))
    }
    
    @IBAction func seeMoreBtnClicked(_ sender: Any) {
        stadiumModel?.isOpen = true
        if moreOrLessBlock != nil {
            moreOrLessBlock!()
        }
    }
    
    @IBAction func seeLessBtnClicked(_ sender: Any) {
        stadiumModel?.isOpen = false
        if moreOrLessBlock != nil {
            moreOrLessBlock!()
        }
    }
 }
