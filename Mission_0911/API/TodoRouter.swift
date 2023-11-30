//
//  TodoRouter.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/17.
//

import Foundation
import Alamofire

enum TodoRouter: URLRequestConvertible {
    case get(page: Int = 1)
    case create(title: String)
    case update(todoId: Int, title: String)
    case delete(todoId: Int)
    case search(term: String,
                page: Int = 1)
    
    // 기본 URL
    var baseURL: URL {
        switch self {
        case .search(let term, let page):
            return URL(string: "\(Storage.Base_URL)\(Storage.searchURL)&query=\(term)&page=\(page)")!
            
        case .get(let page):
            return URL(string: "\(Storage.Base_URL)\(Storage.readURL)&page=\(page)")!
            
        case .create:
            return URL(string: "\(Storage.Base_URL)\(Storage.postJsonURL)")!
            
        case .update(let todoId, _):
            return URL(string: "\(Storage.Base_URL)\(Storage.postJsonURL)/\(todoId)")!
            
        case .delete(let todoId):
            return URL(string: "\(Storage.Base_URL)/\(todoId)")!
        }
    }
    
    
    var method: HTTPMethod {
        switch self {
        case .get, .search:           return .get
        case .create, .update:        return .post
        case .delete:                 return .delete
        }
    }
    
    
    var parameters: [String: String]? {
        switch self  {
        case .create(title: let title), .update(_, title: let title):
            return ["title" : title,
                    "is_done" : "false"]
            
        case .get, .delete, .search:
            return nil
        }
    }
    
    
    // MARK: - asURLRequest
    // URLRequest가 생성될 때 이 함수가 호출 됨
    func asURLRequest() throws -> URLRequest {
        let url = self.baseURL
        
        var request = URLRequest(url: url)
            request.method = self.method
        
        // Create / Update 일 때만 파라미터 추가
        if let params = self.parameters {

            request.httpBody = try JSONSerialization.data(withJSONObject: params,
                                                          options: .prettyPrinted)
            
            //            request = try URLEncodedFormParameterEncoder().encode(params,
            //                                                                  into: request)
        }
        return request
    }
}
