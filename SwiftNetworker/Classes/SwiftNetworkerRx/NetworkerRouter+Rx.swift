//
//  NetworkerRouter+Rx.swift
//  Pods
//
//  Created by Igor on 10/16/17.
//
//

import RxSwift
import ObjectMapper

extension NetworkerRouter {
    
    /// Make request with JSON Dictionary Rx response
    ///
    /// - Returns: NetworkerJSONResult Observable
    @discardableResult
    public func requestJSONRx() -> Observable<NetworkerJSONResult> {
        return Observable.create({ (observer) -> Disposable in
            let request = self.requestJSON(callback: { (result) in
                observer.onNext(result)
                observer.onCompleted()
            })
            return Disposables.create { request?.cancel() }
        })
    }
    
    /// Make request with Mappable Rx response
    ///
    /// - Returns: NetworkerMappableResult Observable
    @discardableResult
    public func requestMappableRx<T: Mappable>() -> Observable<NetworkerMappableResult<T>> {
        return Observable.create({ (observer) -> Disposable in
            let request = self.requestMappable(callback: { (result: NetworkerMappableResult<T>) in
                observer.onNext(result)
                observer.onCompleted()
            })
            return Disposables.create { request?.cancel() }
        })
    }
}
