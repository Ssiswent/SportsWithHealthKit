//
//  YPNavigationController+Configure.swift
//  DigitalCash
//
//  Created by Ssiswent on 2020/7/24.
//

import Foundation

extension YPNavigationController : NavigationBarConfigureStyle {
    public func yp_navigtionBarConfiguration() -> YPNavigationBarConfigurations {
        [.backgroundStyleTransparent,.styleBlack]
    }
    
    public func yp_navigationBarTintColor() -> UIColor! {
        .black
    }
}
