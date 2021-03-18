//
//  INSFindViewController.swift
//  HaveYouReadToday
//
//  Created by Flamingo on 2020/12/12.
//

import UIKit

class INSFindViewController: INSBaseViewController {
    
    @IBOutlet weak var avatarImgView: UIImageView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var publishBtn: UIButton!
    @IBOutlet weak var goTopBtn: UIButton!
    
    var tableVM: INSFindTableVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if INSAccountManager.shared.isLogin {
            avatarImgView.sd_setImage(with: URL(string: (INSAccountManager.shared.user?.head)!), placeholderImage: #imageLiteral(resourceName: "pic_user_default"), options: .continueInBackground, completed: nil)
        }
    }
    
    func initialSetUp()
    {
        topViewHeight.constant = KDeviceTopHeight + 10
        
        setTableView()
        view.bringSubviewToFront(publishBtn)
        view.bringSubviewToFront(goTopBtn)
    }
    
    func setTableView()
    {
        addTableView()
        tableVM = INSFindTableVM(table: tableView!)
        tableVM.publishBtn = publishBtn
        tableVM.goTopBtn = goTopBtn
        tableView?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-KDeviceBottomHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(10)
        })
        tableVM.setTableView()
        tableVM.btnAddTarget()
        tableVM.build()
        tableVM.reload()
        tableVM.loadTalkData()
    }
}

extension INSFindViewController: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return .hidden
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .white
    }
}
