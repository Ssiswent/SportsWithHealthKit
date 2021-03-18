//
//  INSPrivacyViewController.swift
//  MVVMForBitCoin
//
//  Created by Flamingo on 2020/12/28.
//

import UIKit

class INSPrivacyViewController: INSBaseViewController {
    
    var titleStr: String = localizableStr("Privacy policy")
    
    var tableVM: INSPrivacyTableVM!
    
    var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setTitle(titleStr)
        setBgView()
        setTableView()
    }
    
    func setBgView() {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.setRadius(10)
        bgView.setShadow(color: UIColor(hexString: "#B11C18", alpha: 0.1), opacity: 1, radius: 5, offset: CGSize(width: 0, height: 1))
        view.addSubview(bgView)
        bgView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(KDeviceTopHeight + 20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-(KBottomSafeAreaValue + 20))
        })
        self.bgView = bgView
    }
    
    func setTableView()
    {
        addTableView()
        tableView?.backgroundColor = .clear
        tableView?.register(INSPrivacyCell.self)
        tableVM = INSPrivacyTableVM(table: tableView!)
        
        tableView?.snp.makeConstraints({ (make) in
            make.top.equalTo(bgView).offset(10)
            make.leading.trailing.equalTo(bgView)
            make.bottom.equalTo(bgView).offset(-10)
        })
        tableVM.build()
        tableVM.reload()
    }
}

extension INSPrivacyViewController: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return [.backgroundStyleOpaque, .backgroundStyleColor, .styleBlack]
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .white
    }
    
    func yp_navigationBackgroundColor() -> UIColor! {
        AppGlobalThemeColor
    }
}
