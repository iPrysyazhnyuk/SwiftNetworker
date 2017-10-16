//
//  Networker+Rx.swift
//  Pods
//
//  Created by Igor on 10/15/17.
//
//

import Alamofire
import ObjectMapper
import RxSwift

extension Networker {
    
    /// Make request with JSON Dictionary Rx response
    ///
    /// - Parameters:
    ///   - url: Full url
    ///   - method: HTTP method
    ///   - params: Parameters
    ///   - encoding: Parameters encoding, if not specified use URLEncoding
    ///   - headers: HTTP headers
    /// - Returns: NetworkerJSONResult Observable
    public static func requestJSONRx(url: String,
                                     method: HTTPMethod,
                                     params: Parameters? = nil,
                                     encoding: ParameterEncoding? = nil,
                                     headers: [String: String]? = nil) -> Observable<NetworkerJSONResult> {
        return Observable.create { (observer) -> Disposable in
            let request = Networker.requestJSON(url: url, method: method, params: params, encoding: encoding, headers: headers) { (result) in
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create { request?.cancel() }
        }
    }
    
    /// Make request with Mappable Rx response
    ///
    /// - Parameters:
    ///   - url: Full url
    ///   - method: HTTP method
    ///   - params: Parameters
    ///   - encoding: Parameters encoding, if not specified use URLEncoding
    ///   - headers: HTTP headers
    /// - Returns: NetworkerMappableResult Observable
    public static func requestMappableRx<T: Mappable>(url: String,
                                       method: HTTPMethod,
                                       params: Parameters? = nil,
                                       encoding: ParameterEncoding? = nil,
                                       headers: [String: String]? = nil) -> Observable<NetworkerMappableResult<T>> {
        return Observable.create({ (observer) -> Disposable in
            let request = Networker.requestMappable(url: url, method: method, params: params, encoding: encoding, headers: headers) { (result: NetworkerMappableResult<T>) in
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create { request?.cancel() }
        })
    }
}
