# SwiftNetworker

[![CI Status](http://img.shields.io/travis/i.prisyagnyuk@gmail.com/SwiftNetworker.svg?style=flat)](https://travis-ci.org/i.prisyagnyuk@gmail.com/SwiftNetworker)
[![Version](https://img.shields.io/cocoapods/v/SwiftNetworker.svg?style=flat)](http://cocoapods.org/pods/SwiftNetworker)
[![License](https://img.shields.io/cocoapods/l/SwiftNetworker.svg?style=flat)](http://cocoapods.org/pods/SwiftNetworker)
[![Platform](https://img.shields.io/cocoapods/p/SwiftNetworker.svg?style=flat)](http://cocoapods.org/pods/SwiftNetworker)

SwiftNetworker simplifies and make HTTP requests structured using Router abstraction.
It means you write REST API requests with special enum cases for better readability and code reuse.
Received response can be automatically parsed into Swift objects using ObjectMapper library.

## Usage

Assume you want to use GitHub REST API for your project to work with Users and Repositories.
Unexpectedly, you need User model :)
```swift
import ObjectMapper

struct User: Mappable {

    var id: Int?
    var name = ""
    var avatarUrl: String?

    init(map: Map) { /* Object Mapper requires constructor */ }

    // Parsing magic happens here, "id", "name", "avatar_url" are JSON response attribute names
    mutating func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        avatarUrl   <- map["avatar_url"]
    }
}
```

Above User object will be parsed from JSON response automatically using SwiftNetworker.
Do you like it ? Then let's create one more model for Repository object owned by User:

```swift
import ObjectMapper

struct Repository: Mappable {

    var id: Int?
    var name = ""
    var owner: User?

    init(map: Map) { /* Object Mapper requires constructor */ }

    mutating func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        owner       <- map["owner"]
    }
}
```

Yes, `owner` variable will be parsed into User object without any extra code.

Ok, it's time to present to you Router that describe GitHub API requests we want to use:

```swift
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
```

Mandatory for Router are: base API url, endpoints, HTTP methods.
Optional are: HTTP headers, encoding type.

If you want to use SwiftNetworker Mappable requests (e.g. response automatically parsed into Swift objects) in response to API call you receive NetworkerMappableResult which can be success or failure.
- success case gives NetworkerMappableResponse structure with: statusCode, parsed object itself, received JSON response dictionary.
- failure case contains Swift Error object that can be easy converted (by Error extension) to NetworkerError with additional information: statusCode, received JSON response dictionary.

Now lets use our GitHubRouter to get user details:
```swift
GitHubRouter
    .getUserDetails(nickname: "git")
    .requestMappable { (result: NetworkerMappableResult<User>) in
        switch result {
        case .success(let response):
            print("status code: \(response.statusCode)")
            print("success getUserInfo, user name: \(response.object.name)")
        case .failure(let error):
            if let statusCode = error.networkerError?.statusCode {
                print("failure status code: \(statusCode)")
            }
        }
}
```

Get array of user's repositories:
```swift
GitHubRouter
    .getUserRepositories(ownerNickname: "git")
    .requestMappable { (result: NetworkerMappableResult<ArrayResponse<Repository>>) in
        switch result {
        case .success(let response):
            print("status code: \(response.statusCode)")
            let reposNames = response.object.array.map { $0.name }
            print("success getUserRepositories, repositories names: \(reposNames)")
        case .failure(let error):
            if let statusCode = error.networkerError?.statusCode {
                print("failure status code: \(statusCode)")
            }
        }
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftNetworker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftNetworker'
```

## Author

Igor Prysyazhnyuk, i.prisyagnyuk@gmail.com

## License

SwiftNetworker is available under the MIT license. See the LICENSE file for more info.
