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
    
    private static func requestJSONMultipard(url: String,
                                             method: HTTPMethod,
                                             params: Parameters,
                                             headers: [String: String]? = nil,
                                             onSuccess: @escaping (_ json: JSON, _ statusCode: Int) -> (),
                                             onError: @escaping (Error) -> ()) {
        let urlRequest = try! URLRequest(url: url,
                                         method: method,
                                         headers: headers)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                func anyToData(value: Any) -> Data {
                    return String(describing: value).data(using: String.Encoding.utf8)!
                }
                
                for (key, value) in params {
                    if let networkerFile = value as? NetworkerFile {
                        multipartFormData.append(networkerFile.data,
                                                 withName: networkerFile.key,
                                                 fileName: networkerFile.fileName,
                                                 mimeType: networkerFile.fileName)
                    } else if let array = value as? [Any] {
                        for element in array {
                            multipartFormData.append(anyToData(value: element), withName: key)
                        }
                    } else {
                        multipartFormData.append(anyToData(value: value), withName: key)
                    }
                }
        },
            with: urlRequest,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        handleAlamofireJSONResponse(dataResponse: response,
                                                    onSuccess: { (dictionary, statusCode) in
                                                        onSuccess(dictionary, statusCode)
                                                    },
                                                    onError: onError)
                    }
                case .failure(let encodingError):
                    onError(NetworkerError(message: encodingError.localizedDescription))
                }
        })
    }
}
