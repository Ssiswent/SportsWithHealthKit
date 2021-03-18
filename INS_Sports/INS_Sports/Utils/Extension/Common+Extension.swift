//
//  Common+Extension.swift
//  Futures-0814
//
//  Created by Ssiswent on 2020/8/20.
//

import Foundation

// MARK: 获取当前时间
// 这里的 type 是指日期的格式 “yyyyMMdd” 或者 “yyyy-MM-dd” 这样子
func nowTime(_ type: String?) -> String {
    let currentDate = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = type ?? "YYYY年M月d日"
    let time = formatter.string(from: currentDate)
    return time
}

// MARK: 前一天的时间
// nowDay 是传入的需要计算的日期
func getLastDay(_ type: String?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = type ?? "YYYY年M月d日"
    
    let currentDate = Date()
    let lastTime: TimeInterval = -(24*60*60) // 往前减去一天的秒数，昨天
    //        let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
    
    let lastDate = currentDate.addingTimeInterval(lastTime)
    let lastDay = dateFormatter.string(from: lastDate)
    return lastDay
}

func currentViewController() -> (UIViewController?) {
    let array = UIApplication.shared.windows
    var window = array[0]
    //   var window = UIApplication.shared.keyWindow
    if window.windowLevel != UIWindow.Level.normal{
        let windows = UIApplication.shared.windows
        for  windowTemp in windows{
            if windowTemp.windowLevel == UIWindow.Level.normal{
                window = windowTemp
                break
            }
        }
    }
    let vc = window.rootViewController
    return currentViewController(vc)
}


func currentViewController(_ vc :UIViewController?) -> UIViewController? {
    if vc == nil {
        return nil
    }
    if let presentVC = vc?.presentedViewController {
        return currentViewController(presentVC)
    }
    else if let tabVC = vc as? UITabBarController {
        if let selectVC = tabVC.selectedViewController {
            return currentViewController(selectVC)
        }
        return nil
    }
    else if let naiVC = vc as? UINavigationController {
        return currentViewController(naiVC.visibleViewController)
    }
    else {
        return vc
    }
}

//国际化
func localizableStr(_ str: String) -> String
{
    let localStr = NSLocalizedString(str, comment: "")
    return localStr
}

//获取系统语言
func getCurrentLanguage() -> String {
    let preferredLang = Bundle.main.preferredLocalizations.first! as NSString
    switch String(describing: preferredLang) {
    case "en-US", "en-CN":
        return "en"//英文
    case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
        return "cn"//中文
    default:
        return "en"
    }
}
