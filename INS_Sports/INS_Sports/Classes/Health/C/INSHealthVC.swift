//
//  INSHealthVC.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/9.
//

import UIKit
import SwiftEntryKit
import DateToolsSwift
import Lottie

class INSHealthVC: INSBaseViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var safeViewH: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    
    var tableVM: INSHealthTableVM!
    
    @IBOutlet weak var settingsView: UIView!
    var lottieView: LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()
    }
    
    func initialSetUp() {
        safeViewH.constant = KStatusBarHeight + 10
        dateLabel.text = Date().format(with: "M月d日")
        addLottieView()
        setTableView()
    }
    
    func addLottieView() {
        lottieView = .init(name: "lottie_settings")
        lottieView?.frame = .zero
        
        lottieView?.contentMode = .scaleAspectFill
        
        lottieView?.loopAnimation = false
        lottieView?.animationSpeed = 4
        settingsView.addSubview(lottieView!)
        
        lottieView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        settingsView.sendSubviewToBack(lottieView!)
    }
    
    @IBAction func settingsBtnClicked(_ sender: Any) {
        lottieView?.play()
        NotificationCenter.default.post(Notification(name: Notification.Name("SetHeightAndWeight")))
    }
    
    func setTableView()
    {
        addTableView()
        tableView?.backgroundColor = .white
        tableVM = INSHealthTableVM(table: tableView!)
        tableVM.setTableView()
        tableView?.snp.makeConstraints({ (make) in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalToSuperview().offset(-KDeviceBottomHeight)
            make.leading.trailing.equalToSuperview()
        })
        tableVM.build()
        tableVM.reload()
    }
}

extension INSHealthVC: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        .hidden
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        UIColor(hexString: "#FFFFFF")
    }
}
