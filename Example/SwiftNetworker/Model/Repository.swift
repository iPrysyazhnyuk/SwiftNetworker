//
//  Repository.swift
//  SwiftNetworker
//
//  Created by Igor on 10/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import ObjectMapper

struct Repository: Mappable {
    
    var id = 0
    var name = ""
    var owner: User?
    
    init(map: Map) { /* Object Mapper requires constructor */ }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        owner       <- map["owner"]
    }
}
