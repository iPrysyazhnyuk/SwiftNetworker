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
    
    case getUserDetails(nickname: String)
    case getUserRepositories(ownerNickname: String)
    case updateUser(name: String, email: String)
    
    var baseUrl: String { return "https://api.github.com/" }
    
    var endpoint: String {
        switch self {
        case .getUserDetails(let nickname):             return "users/\(nickname)"
        case .getUserRepositories(let ownerNickname):   return "users/\(ownerNickname)/repos"
        case .updateUser:                               return "user/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserDetails,
             .getUserRepositories:
            return .get
            
        case .updateUser:
            return .patch
        }
    }
    
    var params: Parameters? {
        switch self {
        case .updateUser(let name, let email):
            return ["name": name,
                    "email": email]
            
        default: return nil
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization": "token OAUTH-TOKEN"]
    }
}
