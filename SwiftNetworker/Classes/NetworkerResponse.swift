//
//  NetworkerResponse.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

public struct NetworkerResponse<T: Mappable> {
    let statusCode: Int
    let value: [String: Any]
    let object: T
    
    init(statusCode: Int,
         value: [String: Any],
         object: T) {
        self.statusCode = statusCode
        self.value = value
        self.object = object
    }
}
