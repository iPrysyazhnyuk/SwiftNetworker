//
//  NetworkerResponse.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

public struct NetworkerMappableResponse<T: Mappable> {
    public let statusCode: Int
    public let object: T
    
    init(statusCode: Int,
         object: T) {
        self.statusCode = statusCode
        self.object = object
    }
}
