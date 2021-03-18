//
//  INSAboutUsViewController.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/25/20.
//

import UIKit
import ViewAnimator

class INSAboutUsViewController: INSBaseViewController {

    @IBOutlet weak var logoImgView: UIImageView!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize() {
        view.backgroundColor = .white
        
        setTitle(localizableStr("About us"))
        
        logoImgView.setRadius(29)
    }
    
    @IBAction func checkUpdateBtnClicked(_ sender: Any) {
        weak var weakSelf = self
        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let upToDateView = INSLatestView(frame: CGRect(x: 0, y: 0, width: 250, height: 350))
            upToDateView.confirmBlock = upToDateView.hideCoverView
            upToDateView.showCoverView()
            weakSelf?.versionLabel.text = localizableStr("Up to date V0.2")
            weakSelf?.versionLabel.textColor = UIColor(hexString: "#FF5959")
            SVProgressHUD.dismiss()
        }
    }
}

extension INSAboutUsViewController: NavigationBarConfigureStyle
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
