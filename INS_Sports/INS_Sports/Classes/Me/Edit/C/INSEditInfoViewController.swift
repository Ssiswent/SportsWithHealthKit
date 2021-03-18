//
//  INSEditInfoViewController.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/25/20.
//

import UIKit

class INSEditInfoViewController: INSBaseViewController {
    
    @IBOutlet private weak var headImgView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var signatureLabel: UILabel!
    
    @IBOutlet private weak var avatarBtn: UIButton!
    @IBOutlet private weak var photoBtn: UIButton!
    @IBOutlet private weak var nameBtn: UIButton!
    @IBOutlet private weak var sigBtn: UIButton!
    @IBOutlet private weak var changeBtn: UIButton!
    @IBOutlet private weak var logoutBtn: UIButton!
    
    var viewModel: INSEditVM!
    
    var changeSuccessBlock: (() -> Void)?
    var logoutBlock: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = INSEditVM(headImgView: headImgView, nameLabel: nameLabel, sigLabel: signatureLabel, avatarBtn: avatarBtn, photoBtn: photoBtn, nameBtn: nameBtn, sigBtn: sigBtn, changeBtn: changeBtn, logoutBtn: logoutBtn)
        viewModel.btnAddTarget()
        viewModel.setProfile()
        viewModel.changeSuccessBlock = changeSuccessBlock
        viewModel.logoutBlock = logoutBlock
        
        initialize()
    }
    
    func initialize() {
        setTitle("个人信息")
        //        navigationController?.navigationBar.tintColor = UIColor(hexString: "#14FF99")
        navigationItem.rightBarButtonItem = .init(title: localizableStr("Save"), style: .plain, target: viewModel, action: #selector(viewModel.changeUserInfoRequest))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNavItem), name: NSNotification.Name(rawValue: "ChangeInfoSucceed"), object: nil)
    }
    
    @objc func setNavItem() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}

extension INSEditInfoViewController: NavigationBarConfigureStyle {
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        [.backgroundStyleColor, .backgroundStyleOpaque, .styleBlack]
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .white
    }
    
    func yp_navigationBackgroundColor() -> UIColor! {
        AppGlobalThemeColor
    }
}
