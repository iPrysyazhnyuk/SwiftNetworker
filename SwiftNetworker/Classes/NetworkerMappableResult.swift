//
//  NetworkerMappableResult.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

enum NetworkerMappableResult<T: Mappable> {
    case success(NetworkerResponse<T>)
    case failure(Error)
}
