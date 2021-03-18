//
//  INSHomeVC.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/10.
//

import UIKit

class INSHomeVC: INSBaseViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    var tableVM: INSHomeTableVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()
        authorizeHealthKit()
    }
    
    func initialSetUp() {
        topViewHeight.constant = KDeviceTopHeight + 10
        addTableView()
        tableVM = INSHomeTableVM(table: tableView!)
        tableView?.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-KDeviceBottomHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(10)
        })
        tableVM.setTableView()
        tableVM.build()
        tableVM.reload()
        tableVM.getStadiumsRequest()
    }
    
    func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            print("HealthKit Successfully Authorized.")
        }
    }
}

extension INSHomeVC: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        .hidden
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .white
    }
}
