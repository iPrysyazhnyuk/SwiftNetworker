//
//  NetworkerError.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

public struct NetworkerError: Error, LocalizedError {
    let value: [String: Any]?
    let message: String?
    let statusCode: Int?
    
    init(value: [String: Any]? = nil,
         message: String = "Unknown error".localized,
         statusCode: Int? = nil) {
        self.value = value
        self.message = message
        self.statusCode = statusCode
    }
    
    public var errorDescription: String? {
        return message
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
