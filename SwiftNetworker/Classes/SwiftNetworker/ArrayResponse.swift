//
//  ArrayResponse.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

open class ArrayResponse<T: Mappable>: Mappable {
    public var array = [T]()
    
    public required init(map: Map) {}
    
    open func mapping(map: Map) {
        array   <- map[Networker.JSONKey.array]
    }
}
