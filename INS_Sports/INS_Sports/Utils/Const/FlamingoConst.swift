//
//  FlamingoConst.swift
//  CashAndFancyBooks
//
//  Created by Ssiswent on 11/24/20.
//

import UIKit

let AppGlobalThemeColor: UIColor = UIColor(hexString: "#FA472F")

/// 不同屏幕尺寸的宽高比例
let KWidthScale: CGFloat = UIScreen.main.bounds.size.width / 375
let KHeightScale: CGFloat = UIScreen.main.bounds.size.height / 667

/// 屏幕的宽高
let KScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let KScreenHeight: CGFloat = UIScreen.main.bounds.size.height

/// 状态栏高度
let KStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height

/// 导航栏高度
let KNavigationBarHeight: CGFloat = 44

/// 状态栏+导航栏高度(顶部高度)
let KDeviceTopHeight = KStatusBarHeight + KNavigationBarHeight

/// 底部安全区高度
let KBottomSafeAreaValue: CGFloat = KStatusBarHeight > 20 ? 34.0 : 0.0

/// TabBar高度
let KTabBarHeight: CGFloat = 49

/// TabBar+底部安全区高度
let KDeviceBottomHeight: CGFloat = KTabBarHeight + KBottomSafeAreaValue

/// 是否为刘海屏
let KIsXSeries: Bool = KStatusBarHeight > 20 ? true : false
