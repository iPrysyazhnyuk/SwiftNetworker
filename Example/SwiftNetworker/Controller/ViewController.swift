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
        getUserInfo()
        getUserRepositories()
    }
    
    private func getUserInfo() {
        GitHubRouter
            .userDetails(nickname: userNickname)
            .requestMappable { (result: NetworkerMappableResult<User>) in
                switch result {
                case .success(let response):
                    print("status code: \(response.statusCode)")
                    print("success getUserInfo, user name: \(response.object.name)")
                case .failure(let error):
                    self.printError(error: error, functionName: "getUserInfo")
                }
        }
    }
    
    private func getUserRepositories() {
        GitHubRouter
            .userRepositories(ownerNickname: userNickname)
            .requestMappable { (result: NetworkerMappableResult<ArrayResponse<Repository>>) in
                switch result {
                case .success(let response):
                    print("status code: \(response.statusCode)")
                    let reposNames = response.object.array.map { $0.name }
                    print("success getUserRepositories, repositories names: \(reposNames)")
                case .failure(let error):
                    self.printError(error: error, functionName: "getUserRepositories")
                }
        }
    }
    
    private func printError(error: Error, functionName: String) {
        if let statusCode = error.networkerError?.statusCode {
            print("status code: \(statusCode)")
        }
        print("failure \(functionName): \(error.localizedDescription)")
    }
}
