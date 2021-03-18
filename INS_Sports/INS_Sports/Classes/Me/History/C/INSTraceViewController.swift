//
//  INSTraceViewController.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/25/20.
//

import UIKit

class INSTraceViewController: INSBaseViewController {

    var tableVM: INSHistoryTableVM!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setTitle("我的足迹")
        setTableView()
        
        navigationItem.rightBarButtonItem = .init(title: "清除", style: .plain, target: tableVM, action: #selector(tableVM.clearFootArr))
        
        navigationItem.rightBarButtonItem?.isEnabled = tableVM.navItemEnable
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNavItem), name: NSNotification.Name(rawValue: "ChangeNavItem"), object: nil)
    }
    
    @objc func setNavItem() {
        navigationItem.rightBarButtonItem?.isEnabled = tableVM.navItemEnable
    }
    
    func setTableView()
    {
        addTableView()
        tableView?.backgroundColor = .white
        tableView?.register(INSTraceCell.self)
        tableVM = INSHistoryTableVM(table: tableView!)
        tableVM.getFootArr()
    }
}

extension INSTraceViewController: NavigationBarConfigureStyle
{
    func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        return [.backgroundStyleOpaque, .backgroundStyleColor, . styleBlack]
    }
    
    func yp_navigationBarTintColor() -> UIColor! {
        .white
    }
    
    func yp_navigationBackgroundColor() -> UIColor! {
        AppGlobalThemeColor
    }
}
