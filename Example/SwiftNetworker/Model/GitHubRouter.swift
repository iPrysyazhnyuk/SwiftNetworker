//
//  GitHubRouter.swift
//  SwiftNetworker
//
//  Created by Igor on 10/15/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Alamofire
import SwiftNetworker

enum GitHubRouter: NetworkerRouter {
    
    case userDetails(nickname: String)
    case userRepositories(ownerNickname: String)
    
    var baseUrl: String { return "https://api.github.com/" }
    
    var endpoint: String {
        switch self {
        case .userDetails(let nickname): return "users/\(nickname)"
        case .userRepositories(let ownerNickname): return "users/\(ownerNickname)/repos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userDetails,
             .userRepositories:
            return .get
        }
    }
}
