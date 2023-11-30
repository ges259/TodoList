//
//  TodoInterceptor.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/18.
//

import Foundation
import Alamofire

final class TodoInterceptor: RequestInterceptor {
    
    // API를 호출할 때, AF.request가 호출할 때 같이 호출 됨
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("TodoInterceptor - \(#function)")
        
        var request = urlRequest
        
        // 헤더 추가 ( headers )
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // completion()
        completion(.success(request))
    }
    
    
    // 실패했을 때
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("TodoInterceptor - \(#function)")
        
        guard let statusCode = request.response?.statusCode else { return }
        
        // Notification 등 활용 가능
        
        print("statusCode: \(statusCode)")
        completion(.doNotRetry)
    }
}
