//
//  NSObject+Extension.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/15.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
