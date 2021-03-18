//
//  INSMineVC.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import UIKit

class INSMineVC: INSBaseViewController {
    
    @IBOutlet weak var nameLabelT: NSLayoutConstraint!
    
    @IBOutlet private weak var editBtn: UIButton!
    @IBOutlet private weak var loginBtn: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sigLabel: UILabel!
    @IBOutlet private weak var avatarImgView: UIImageView!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var viewModel: INSMeVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
        viewModel = INSMeVM(nameLabel: nameLabel, sigLabel: sigLabel, avatarImgView: avatarImgView, editBtn: editBtn, loginBtn: loginBtn, collectionView: collectionView)
        viewModel.setCollectionView()
        viewModel.judgeIsLogin()
        viewModel.btnAddTarget()
        
        NotificationCenter.default.addObserver(viewModel!, selector: #selector(viewModel.loginSuccess), name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
    }
    
    func initialize()
    {
        if !KIsXSeries {
            nameLabelT.constant = 20 * KHeightScale
        }
    }
}

extension INSMineVC: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        .hidden
//        [.backgroundStyleTransparent, .styleBlack]
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        UIColor(hexString: "#FFFFFF")
    }
}
