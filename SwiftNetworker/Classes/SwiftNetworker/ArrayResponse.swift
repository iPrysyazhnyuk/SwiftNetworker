//
//  ArrayResponse.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

public class ArrayResponse<T: Mappable>: Mappable {
    public var array = [T]()
    
    public required init(map: Map) {
        mapping(map: map)
    }
    
    public func mapping(map: Map) {
        array   <- map[Networker.JSONKey.array]
    }
}
