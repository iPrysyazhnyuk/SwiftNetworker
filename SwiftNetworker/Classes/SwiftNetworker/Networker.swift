//
//  Networker.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import Alamofire
import ObjectMapper

class Networker {
    
    public struct JSONKey {
        static let array = "array"
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
            onError(NetworkerError(message: "Missing response".localized))
            return
        }
        
        var responseValue: JSON = [:]
        if let objectValue = result.value as? JSON {
            responseValue = objectValue
        } else if let arrayValue = result.value as? [Any] {
            // If we got array made dictionary from it for object mapper
            responseValue = [JSONKey.array: arrayValue as Any]
        }
        
        let statusCode = response.statusCode
        if statusCode < 300 { onSuccess(responseValue, statusCode) }
        else { onError(NetworkerError(value: responseValue, statusCode: statusCode)) }
    }
    
    private static func requestJSONMultipart(url: String,
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
    
    /// Check parameters and make request with JSON Dictionary response. Can be multipart if parameters contain NetworkerFile
    ///
    /// - Parameters:
    ///   - url: Full url
    ///   - method: HTTP method
    ///   - params: Parameters
    ///   - encoding: Parameters encoding, if not specified use URLEncoding
    ///   - headers: HTTP headers
    ///   - onSuccess: Closure for success response
    ///   - onError: Closure for error response
    /// - Returns: NetworkerRequest you can use for example to cancel request
    @discardableResult
    private static func requestJSON(url: String,
                                    method: HTTPMethod,
                                    params: Parameters? = nil,
                                    encoding: ParameterEncoding? = nil,
                                    headers: [String: String]? = nil,
                                    onSuccess: @escaping (_ json: JSON, _ statusCode: Int) -> (),
                                    onError: @escaping (Error) -> ()) -> NetworkerRequest? {
        var request: NetworkerRequest?
        // If parameters contain NetworkerFile make multipart request
        if let params = params,
            params.values.contains(where: { $0 is NetworkerFile }) {
            requestJSONMultipart(url: url,
                                 method: method,
                                 params: params,
                                 headers: headers,
                                 onSuccess: onSuccess,
                                 onError: onError)
        } else {
            request = Alamofire.request(url,
                                        method: method,
                                        parameters: params,
                                        encoding: encoding ?? URLEncoding.default,
                                        headers: headers).responseJSON { (dataResponse) in
                                            handleAlamofireJSONResponse(dataResponse: dataResponse, onSuccess: { (dictionary, statusCode) in
                                                onSuccess(dictionary, statusCode)
                                            }, onError: onError)
            }
        }
        return request
    }
    
    /// Make request with JSON Dictionary response
    ///
    /// - Parameters:
    ///   - url: Full url
    ///   - method: HTTP method
    ///   - params: Parameters
    ///   - encoding: Parameters encoding, if not specified use URLEncoding
    ///   - headers: HTTP headers
    ///   - callback: Closure with JSON result
    /// - Returns: NetworkerRequest you can use for example to cancel request
    @discardableResult
    public static func requestJSON(url: String,
                                    method: HTTPMethod,
                                    params: Parameters? = nil,
                                    encoding: ParameterEncoding? = nil,
                                    headers: [String: String]? = nil,
                                    callback: @escaping (NetworkerJSONResult) -> ()) -> NetworkerRequest? {
        return requestJSON(url: url, method: method, params: params, encoding: encoding, headers: headers, onSuccess: { (json, statusCode) in
            callback(NetworkerJSONResult.success(NetworkerJSONResponse(statusCode: statusCode, json: json)))
        }) { (error) in
            callback(NetworkerJSONResult.failure(error))
        }
    }
    
    /// Make request with Mappable response
    ///
    /// - Parameters:
    ///   - url: Full url
    ///   - method: HTTP method
    ///   - params: Parameters
    ///   - encoding: Parameters encoding, if not specified use URLEncoding
    ///   - headers: HTTP headers
    ///   - callback: Closure with Mappable result
    /// - Returns: NetworkerRequest you can use for example to cancel request
    @discardableResult
    public static func requestMappable<T: Mappable>(url: String,
                                        method: HTTPMethod,
                                        params: Parameters? = nil,
                                        encoding: ParameterEncoding? = nil,
                                        headers: [String: String]? = nil,
                                        callback: @escaping (NetworkerMappableResult<T>) -> ()) -> NetworkerRequest? {
        return requestJSON(url: url, method: method, params: params, encoding: encoding, headers: headers, onSuccess: { (json, statusCode) in
            // Run async because JSON parsing can be slow
            DispatchQueue.global().async {
                let object = T(JSON: json)
                DispatchQueue.main.async {
                    if let object = object {
                        let networkerResponse = NetworkerMappableResponse(statusCode: statusCode, object: object)
                        callback(NetworkerMappableResult.success(networkerResponse))
                    }
                    else {
                        callback(NetworkerMappableResult.failure(NetworkerError(message: "Can't parse response".localized)))
                    }
                }
            }
        }) { (error) in
            callback(NetworkerMappableResult.failure(error))
        }
    }
}

public protocol NetworkerRequest {
    func cancel()
}

extension DataRequest: NetworkerRequest {
    // Adapter to NetworkerRequest
}
