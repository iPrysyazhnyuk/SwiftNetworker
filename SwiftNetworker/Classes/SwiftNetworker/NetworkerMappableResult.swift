//
//  NetworkerMappableResult.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

public enum NetworkerMappableResult<T: Mappable> {
    case success(NetworkerMappableResponse<T>)
    case failure(Error)
}
