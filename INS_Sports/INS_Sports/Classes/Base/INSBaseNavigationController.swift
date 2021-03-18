//
//  INSBaseNavigationController.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import UIKit

class INSBaseNavigationController: YPNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0
        {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: true)
    }
}
