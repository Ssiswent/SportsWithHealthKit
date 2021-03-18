//
//  INSCommentModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import Foundation

@objcMembers
class INSCommentModel: NSObject {
    var id: String?
    var content: String?
    var user: INSUserModel?
    var userId: String?
    var talkId: String?
    var time: Int = 0
}
