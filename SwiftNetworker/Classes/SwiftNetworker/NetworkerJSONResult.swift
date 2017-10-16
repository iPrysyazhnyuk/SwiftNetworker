//
//  NetworkerResult.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

public typealias JSON = [String: Any]

public enum NetworkerJSONResult {
    case success(NetworkerJSONResponse)
    case failure(Error)
}
