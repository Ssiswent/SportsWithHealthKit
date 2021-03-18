//
//  INSStadiumModel.swift
//  INS_Sports
//
//  Created by Flamingo on 2021/3/2.
//

import Foundation

@objcMembers
class INSStadiumModel: NSObject, Codable {
    var address: String?
    var businessTime: String?
    var id: String?
    var image: String?
    var number: String?
    var prices: String?
    var title: String?
    var typeName: String?
    var updateTime: String?
    
    var isOpen: Bool = false
    var isCollected: Bool = false
}
