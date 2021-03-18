//
//  INSUserModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import Foundation

@objcMembers
class INSUserModel: NSObject, Codable {
    var id: String?
    var nickName: String?
    var signature: String?
    var head: String?
    var followCount: Int = 0
    var fansCount: Int = 0
    var talkCount: Int = 0
    var phone: String?
    var password: String?
}
