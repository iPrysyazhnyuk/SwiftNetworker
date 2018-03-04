//
//  User.swift
//  SwiftNetworker
//
//  Created by Igor on 10/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import ObjectMapper

struct User: Mappable {
    
    var id: Int?
    var name = ""
    var avatarUrl: String?
    
    init(map: Map) { /* Object Mapper requires constructor */ }
    
    // Parsing magic happens here, "id", "name", "avatar_url" are JSON response attribute names
    mutating func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        avatarUrl   <- map["avatar_url"]
    }
}
