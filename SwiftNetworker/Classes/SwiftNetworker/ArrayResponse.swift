//
//  ArrayResponse.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

public struct ArrayResponse<T: Mappable>: Mappable {
    public var array = [T]()
    
    public init(map: Map) {
        mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        array   <- map[Networker.JSONKey.array]
    }
}
