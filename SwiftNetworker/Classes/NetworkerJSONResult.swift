//
//  NetworkerResult.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

typealias JSON = [String: Any]

enum NetworkerJSONResult {
    case success(JSON)
    case failure(Error)
}
