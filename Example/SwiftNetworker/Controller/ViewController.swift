//
//  ViewController.swift
//  SwiftNetworker
//
//  Created by Igor Prysyazhnyuk on 10/15/2017.
//  Copyright (c) 2017 Igor Prysyazhnyuk. All rights reserved.
//

import UIKit
import SwiftNetworker

class ViewController: UIViewController {

    private let userNickname = "git"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfoSimplified()
        getUserInfo()
        getUserInfoWithoutRouterAndJSONParsing()
        getUserRepositoriesSimplified()
        updateUserInfoWithoutResponseHandling()
    }
    
    /// Get only User object without status code, JSON dictionary for success response
    private func getUserInfoSimplified() {
        GitHubRouter
            .getUserDetails(nickname: userNickname)
            .requestMappable(onSuccess: { (user: User) in
                print("success getUserInfoSimplified, user name: \(user.name)")
            }) { (error) in
                let networkerError = error.networkerError
                if let statusCode = networkerError?.statusCode {
                    print("failure status code: \(statusCode)")
                }
                if let json = networkerError?.info {
                    print("failure json: \(json)")
                }
        }
    }
    
    private func getUserInfo() {
        GitHubRouter
            .getUserDetails(nickname: userNickname)
            .requestMappable { (result: NetworkerMappableResult<User>) in
                switch result {
                case .success(let response):
                    print("status code: \(response.statusCode)")
                    print("success getUserInfo, user name: \(response.object.name)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    private func getUserInfoWithoutRouterAndJSONParsing() {
        Networker.requestJSON(url: "https://api.github.com/users/git",
                              method: .get,
                              onSuccess: { (json, statusCode) in
            print("success getUserInfoWithoutRouterAndJSONParsing, json: \(json)")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getUserRepositoriesSimplified() {
        GitHubRouter
            .getUserRepositories(ownerNickname: userNickname)
            .requestMappable(onSuccess: { (repositories: ArrayResponse<Repository>) in
                let reposNames = repositories.array.map { $0.name }
                print("success getUserRepositoriesSimplified, repository names: \(reposNames)")
            }, onError: { (error) in
                print(error.localizedDescription)
            })
    }
    
    private func updateUserInfoWithoutResponseHandling() {
        GitHubRouter
            .updateUser(name: "new name",
                        email: "new_email@mail.com")
            .request()
    }
}
