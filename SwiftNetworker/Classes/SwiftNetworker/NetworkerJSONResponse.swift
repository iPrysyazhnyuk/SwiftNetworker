//
//  NetworkerJsonResponse.swift
//  Pods
//
//  Created by Igor on 10/16/17.
//
//

public struct NetworkerJSONResponse {
    public let statusCode: Int
    public let json: JSON
    
    init(statusCode: Int,
         json: JSON) {
        self.statusCode = statusCode
        self.json = json
    }
}
