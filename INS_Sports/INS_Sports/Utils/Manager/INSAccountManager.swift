//
//  INSAccountManager.swift
//  Futures_Remix
//
//  Created by Ssiswent on 2020/9/27.
//

import UIKit

class INSAccountManager: NSObject {
    static let shared = INSAccountManager()
    
    static let language: String = getCurrentLanguage()
    
    /// 用户是否登录 默认为 0  0: 否  1: 是
    var isLogin: Bool {
        get {
            return get(Key.ISLOGIN, false)
        }
        set {
            set(newValue, Key.ISLOGIN)
        }
    }
    /// 缓存用户登录信息
    var user: INSUserModel? {
        get {
            return INSUserModel.mj_object(withKeyValues: get(Key.USERM, [:]))
        }
        set {
            set(newValue?.mj_keyValues() ?? [:], Key.USERM)
        }
    }
    /// 缓存登录账号
    var account: String {
        get {
            return get(Key.ACCOUNT, "")
        }
        set {
            set(newValue, Key.ACCOUNT)
        }
    }
    /// 缓存登录密码
    var psw: String {
        get {
            return get(Key.PSW, "")
        }
        set {
            set(newValue, Key.PSW)
        }
    }
    /// 缓存登录id
    var userId: String {
        get {
            return get(Key.USERID, "")
        }
        set { set(newValue, Key.USERID)
        }
    }
    
    fileprivate func set(_ value: Any, _ key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func get<T>(_ key: String, _ defaults: T) -> T {
        if let value = UserDefaults.standard.value(forKey: key) {
            // swiftlint:disable force_cast
            return value as! T
            // swiftlint:enable force_cast
        } else {
            return defaults
        }
    }
    
    class Key: NSObject {
        static let ISLOGIN = "ISLOGIN"
        static let ACCOUNT = "ACCOUNT"
        static let PSW = "PSW"
        static let USERID = "USERID"
        static let USERM = "USERM"
    }
}
