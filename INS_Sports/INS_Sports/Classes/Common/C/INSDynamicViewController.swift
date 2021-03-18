//
//  INSDynamicViewController.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/24/20.
//

import UIKit

class INSDynamicViewController: INSBaseViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgImgViewBottom: NSLayoutConstraint!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    @IBOutlet weak var followCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var dynamicsCountLabel: UILabel!
    
    fileprivate lazy var newsSource = [INSTalkModel]()
    
    var userModel: INSUserModel?
    
    var isMineDynamic: Bool = false
    
    var alpha: CGFloat?
    
    var oriH: CGFloat?
    var oriOffsetY: CGFloat?
    
    var navImg: UIImage?
    
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    var isFollow:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
        getTalks(pageNum: 1)
    }
    
    func initialize()
    {
        view.backgroundColor = UIColor(hexString: "#F6F6F6")
        bgView.backgroundColor = UIColor(hexString: "#F6F6F6")
        profileView.backgroundColor = .clear
        
        bgImgViewBottom.constant = 325 - (225 * KScreenWidth) / 375
        
        title = (userModel?.nickName)!
        
        setTableView()
        setUpUser()
        
        if KIsXSeries {
            oriH = 325
        } else {
            oriH = 325
        }
        
        oriOffsetY = -(oriH!)
        
        headImgView.setRadius(45)
        
        setTableViewContentInset()
    }
    
    func setTableView()
    {
        addTableView()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = .clear
        addHeader(pageNum: 1)
        addFooter(pageNum: 1)
        registerCell(cell: INSHuDongTalkCell.self)
        
        view.bringSubviewToFront(headerView)
    }
    
    func setUpUser()
    {
        followCountLabel.text = "\(userModel?.followCount ?? 0)"
        followerCountLabel.text = "\(userModel?.fansCount ?? 0)"
        if let headStr = userModel?.head
        {
            headImgView.sd_setImage(with: URL(string: headStr), placeholderImage: #imageLiteral(resourceName: "pic_user_default"), options: .continueInBackground, completed: nil)
        }
        nameLabel.text = userModel?.nickName
        signatureLabel.text = userModel?.signature
    }
}

extension INSDynamicViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.viewDisplayImage(withMsg: "暂无动态", lottieStr: "lottie_empty", action: {}, ifNecessaryForRowCount: talksArray.count)
        return talksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: INSHuDongTalkCell.reuseID, for: indexPath) as! INSHuDongTalkCell
        let cellModel = INSHuDongTalkCellModel()
        cellModel.model = talksArray[indexPath.row]
        cell.model = cellModel
        return cell
        // swiftlint:enable force_cast
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            UIView()
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            0.0001
        }
}

// MARK: setNavFade
extension INSDynamicViewController: NavigationBarConfigureStyle
{
    func setTableViewContentInset()
    {
        tableView?.contentInsetAdjustmentBehavior = .never
        tableView?.contentInset = UIEdgeInsets(top: -oriOffsetY!, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - oriOffsetY!
        var h = oriH! - offset
        if h <= KDeviceTopHeight
        {
            h = KDeviceTopHeight
        }
        headerViewHeight.constant = h
        
        var alpha = offset * 1 / (oriH! - KDeviceTopHeight)
        if alpha >= 0.99
        {
            alpha = 0.99
        }
        self.alpha = alpha
        
//        let originalImg = #imageLiteral(resourceName: "daohanglan")
//        let alphaImg = originalImg.image(byApplyingAlpha: alpha)
//        navImg = alphaImg
        
        if alpha <= 1
        {
            yp_refreshNavigationBarStyle()
        }
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#000000", alpha: alpha)]
    }
    
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        if alpha! <= 0
        {
            return [.backgroundStyleTransparent]
        }
        else if alpha! > 0 && alpha! <= 0.44
        {
            return [.backgroundStyleColor]
        }
        else
        {
            return [.backgroundStyleColor]
        }
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        UIColor(hexString: "#000000")
    }
    
    func yp_navigationBackgroundColor() -> UIColor! {
        UIColor(hexString: "#F6F6F6", alpha: alpha)
    }
    
//    func yp_navigationBackgroundImage(withIdentifier identifier: AutoreleasingUnsafeMutablePointer<NSString?>!) -> UIImage! {
//        navImg
//    }
}
