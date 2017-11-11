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
    
    /// JSON dictionary
    public let json: JSON
}
