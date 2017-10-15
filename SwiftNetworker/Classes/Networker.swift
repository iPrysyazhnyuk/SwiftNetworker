//
//  Networker.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import Alamofire

class Networker {
    
    enum JSONKey: String {
        case array
        case string
    }
    
    private static func handleAlamofireJSONResponse(dataResponse: DataResponse<Any>,
                                                onSuccess: (_ json: JSON, _ statusCode: Int) -> (),
                                                onError: (Error) -> ()) {
        let result = dataResponse.result
        if let error = result.error {
            onError(error)
            return
        }
        
        guard let response = dataResponse.response else {
            callNoReponseError(onError: onError)
            return
        }
        
        var responseValue: JSON = [:]
        if let objectValue = result.value as? JSON {
            responseValue = objectValue
        } else if let arrayValue = result.value as? [Any] {
            // If we got array made dictionary from it for object mapper
            responseValue = [JSONKey.array.rawValue: arrayValue as Any]
        } else if let string = result.value as? String {
            // If we got string made dictionary from it for object mapper
            responseValue = [JSONKey.string.rawValue: string as Any]
        }
        
        let statusCode = response.statusCode
        if statusCode < 300 { onSuccess(responseValue, statusCode) }
        else { onError(NetworkerError(value: responseValue, statusCode: statusCode)) }
    }
    
    private static func callNoReponseError(onError: (Error) -> ()) {
        onError(NetworkerError(message: "No response".localized))
    }
}
