//
//  SVProgressHUD+Extension.swift
//  Futures-0814
//
//  Created by Ssiswent on 2020/8/14.
//

import Foundation

extension SVProgressHUD{
    static func gp_show(){
        config()
        show()
    }
    
    static func gp_show(withStatus:String,delay:TimeInterval = 0){
        config()
        show(withStatus: withStatus)
        if delay != 0 {
            dismiss(withDelay: delay)
        }
    }
    
    static func gp_showInfo(withStatus:String,delay:TimeInterval = 0){
        config()
        showInfo(withStatus: withStatus)
        if delay != 0 {
            dismiss(withDelay: delay)
        }
    }
    
    static func gp_showError(withStatus:String,delay:TimeInterval = 0){
        config()
        showError(withStatus: withStatus)
        if delay != 0 {
            dismiss(withDelay: delay)
        }
    }
    
    static func gp_showSuccess(withStatus:String,delay:TimeInterval = 0){
        config()
        showSuccess(withStatus: withStatus)
        if delay != 0 {
            dismiss(withDelay: delay)
        }
    }
    
    private static func config(){
        setDefaultAnimationType(.native)
        setDefaultMaskType(.clear)
        setDefaultStyle(.dark)
    }
}
