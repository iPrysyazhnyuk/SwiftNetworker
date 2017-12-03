//
//  NetworkerError.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import ObjectMapper

public struct NetworkerError: Error, LocalizedError {
    
    static let unknownError = "Unknown error".localized
    
    /// Additional info in JSON format, can be response from server
    public let info: JSON?
    
    /// HTTP status code
    public let statusCode: Int?
    
    let message: String?
    
    public init(info: JSON? = nil,
         message: String = NetworkerError.unknownError,
         statusCode: Int? = nil) {
        self.info = info
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

extension Error {
    
    public var networkerError: NetworkerError? { return self as? NetworkerError }
    
    /// Parse error if it's NetworkerError
    ///
    /// - Returns: Mappable object
    public func parse<T: Mappable>() -> T? {
        guard let networkerError = networkerError,
            let info = networkerError.info else { return nil }
        return T(JSON: info)
    }
}
