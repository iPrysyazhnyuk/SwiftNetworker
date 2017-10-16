//
//  NetworkerResponse.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

public struct NetworkerMappableResponse<T: Mappable> {
    
    /// HTTP status code
    public let statusCode: Int
    
    /// Parsed Mappable object
    public let object: T
    
    init(statusCode: Int,
         object: T) {
        self.statusCode = statusCode
        self.object = object
    }
}
