# SwiftNetworker

[![CI Status](http://img.shields.io/travis/i.prisyagnyuk@gmail.com/SwiftNetworker.svg?style=flat)](https://travis-ci.org/i.prisyagnyuk@gmail.com/SwiftNetworker)
[![Version](https://img.shields.io/cocoapods/v/SwiftNetworker.svg?style=flat)](http://cocoapods.org/pods/SwiftNetworker)
[![License](https://img.shields.io/cocoapods/l/SwiftNetworker.svg?style=flat)](http://cocoapods.org/pods/SwiftNetworker)
[![Platform](https://img.shields.io/cocoapods/p/SwiftNetworker.svg?style=flat)](http://cocoapods.org/pods/SwiftNetworker)

SwiftNetworker simplifies and makes HTTP requests code structured using Router abstraction.
It means you write REST API requests with enum cases for better readability and code reuse.
Received HTTP response automatically parsed into Swift objects using ObjectMapper library.

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

Ok, it's time to present to you Router that describes GitHub API calls we want to use to:
- get user details
- get repositories owned by user
- update user info
```swift
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
        switch self {
        case .updateUser: return ["Authorization": "token OAUTH-TOKEN"]
        default: return nil
        }
    }
}
```
Mandatory for Router are: base API url, endpoints, HTTP methods.
Optional are: HTTP headers, encoding type.

Now lets use our GitHubRouter to get user details:
```swift
GitHubRouter
    .getUserDetails(nickname: "git")
    .requestMappable(onSuccess: { (user: User) in
        print("user name: \(user.name)")
    }) { (error) in
        let networkerError = error.networkerError
        if let statusCode = networkerError?.statusCode {
            print("failure status code: \(statusCode)")
        }
        if let json = networkerError?.info {
            print("failure json: \(json)")
        }
}
```
Error object can be easy converted (by Error extension) to `NetworkerError` with additional information: statusCode, received JSON response dictionary. Error response means any request issues (e.g. missing network connection) or response with Client(4xx) or Server(5xx) error status codes.

If you want to get response HTTP status code, JSON dictionary along with parsed Object you can use another method with `NetworkerMappableResult` callback which can be success or failure.
- success case gives `NetworkerMappableResponse` structure with: statusCode, parsed object itself, received JSON response dictionary.
- failure case contains Swift Error object
```swift
GitHubRouter
    .getUserDetails(nickname: "git")
    .requestMappable { (result: NetworkerMappableResult<User>) in
        switch result {
        case .success(let response):
            print("status code: \(response.statusCode)")
            print("user name: \(response.object.name)")
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
    .requestMappable(onSuccess: { (repositories: ArrayResponse<Repository>) in
        let reposNames = repositories.array.map { $0.name }
        print("repositories names: \(reposNames)")
    }, onError: { (error) in
        print(error.localizedDescription)
    })
```

Update user info without response handling:
```swift
GitHubRouter
    .updateUser(name: "new name",
                email: "new_email@mail.com")
    .request()
```

Upload photo or other Data? Easy, just create `NetworkerFile` and pass it as param to Router:
```swift
let photoFile = NetworkerFile(image: UIImage(),
                              key: "photo",
                              name: "photo.png",
                              imageFormat: .png)
Router
    .uploadPhoto(photo: photoFile)
    .request()
```

Using of Router is recommended but not required, the same for automatic JSON parsing - it's optional, you can still receive JSON and parse manually:
```swift
Networker.requestJSON(url: "https://api.github.com/users/git",
                      method: .get,
                      onSuccess: { (json, statusCode) in
    print("success, json: \(json)")
}) { (error) in
    print(error.localizedDescription)
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 8.0+
* Swift 3.2+

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
