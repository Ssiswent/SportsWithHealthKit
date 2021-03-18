//
//  InsTalkModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import Foundation

@objcMembers
class INSTalkModel: NSObject, Codable {
    var id: Int = 0
    var content: String?
    var picture: String?
    var user: INSUserModel?
    var publishTime: String?
    var commentCount: Int = 0
    var zanCount: Int = 0
    var hasZan: Bool = false
    var browserCount:Int = 0
    var forwardCount:Int = 0
    var displayBig: Bool = false
}
