//
//  User.swift
//  SwiftNetworker
//
//  Created by Igor on 10/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import ObjectMapper

struct User: Mappable {
    var id = 0
    var name = ""
    var avatarUrl = ""
    
    init(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        avatarUrl   <- map["avatar_url"]
    }
}
