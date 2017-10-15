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
                    print("success getUserInfo, user name: \(response.object.name)")
                case .failure(let error):
                    print("failure getUserInfo: \(error.localizedDescription)")
                }
        }
    }
    
    private func getUserRepositories() {
        GitHubRouter
            .userRepositories(ownerNickname: userNickname)
            .requestMappable { (result: NetworkerMappableResult<ArrayResponse<Repository>>) in
                switch result {
                case .success(let response):
                    let reposNames = response.object.array.map { $0.name }
                    print("success getUserRepositories, repositories names: \(reposNames)")
                case .failure(let error):
                    print("failure getUserRepositories: \(error.localizedDescription)")
                }
        }
    }
}

