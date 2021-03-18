//
//  UIViewController+Extension.swift
//  Futures-0814
//
//  Created by Ssiswent on 2020/8/14.
//

import UIKit

extension UIViewController
{
    /// dismiss到根控制器
    func dismissToRootViewController() {
        var vc: UIViewController = self
        while vc.presentingViewController != nil {
            vc = vc.presentingViewController!
        }
        vc.dismiss(animated: true)
    }
    
    func setTitle(_ t: String, tintColor: UIColor? = UIColor(hexString: "#FFFFFF")) {
        title = t
        let titleLabel = UILabel()
        
        titleLabel.textColor = tintColor
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    func presentTransparentViewController(_ viewController: UIViewController, _ animated: Bool, _ completion: @escaping () -> Void) {
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.present(viewController, animated: animated, completion: completion)
    }
}
