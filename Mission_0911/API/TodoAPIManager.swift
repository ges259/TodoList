//
//  TodoAPIManager.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/18.
//

import Foundation
import Alamofire

final class TodoAPIManager {
    // 싱글톤
    static let shared: TodoAPIManager = TodoAPIManager()
    
    // 인터셉터
    // api호출 시 중간에 (공통 파라미터 또는 토큰 인증)등을 넣을 수 있다.
    let interceptors = Interceptor(interceptors: [TodoInterceptor()])
    
    // 로거 설정
    let monitors = [TodoLogger()] as [EventMonitor]
    
    // 세션
    var session: Session
    
    // 생성자 - 세션에 데이터 -
    init() {
        self.session = Session(
            interceptor: self.interceptors,
            eventMonitors: self.monitors
        )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // typealias
    typealias TodoDataCompletion = (Result<TodoData, NetWorkError>) -> Void
    typealias TodoListCompletion = (Result <TodoList, NetWorkError>) -> Void
    
    // MARK: - 한글 인코딩
    // String_Encoding
    private func makeStringKoreanEncoded(_ string: String) -> String {
        return string.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? string
    }
    
    
    // MARK: - 데이터 파싱
    /** Parse Data */
    private func parseData(data: Data) -> TodoData? {
        do {
            let todoData = try JSONDecoder().decode(TodoData.self,
                                                    from: data) // decode
            return todoData
            
            // data가 없다면
        } catch {
            return nil
        }
    }
    
    private func todoListParsing(data: Data) -> TodoList? {
        do {
            let todoData = try JSONDecoder().decode(TodoList.self,
                                                    from: data) // decode
            return todoData
            
            // data가 없다면
        } catch {
            return nil
        }
    }
    
    
    
    
    
    
    // MARK: - 데이터 가져오기 ( Read )
    func alamoFireRead(page: Int = 1,
                       completion: @escaping TodoDataCompletion) {
        self.session
            .request(TodoRouter.get(page: page))
            .validate(statusCode: 200..<401)
            .responseData { result in
                guard let data = result.data else { return }
                
                if let todoDatas = self.parseData(data: data) {
                    return completion(.success(todoDatas))
                } else {
                    return completion(.failure(.parseError))
                }
            }
    }
    
    
    
    // MARK: - 데이터 검색 ( Search )
    func alamoFireSearch(page: Int = 1,
                         title: String,
                         completion: @escaping TodoDataCompletion) {
        let text = self.makeStringKoreanEncoded(title)
        
        self.session
            .request(TodoRouter.search(term: text, page: page))
            .validate(statusCode: 200..<401)
            .responseData { result in
                guard let safeData = result.data else {
                    return completion(.failure(.NoSearchResult))
                }
                if let todoData = self.parseData(data: safeData)  {
                    print("***********************Fetch 성공***********************")
                    return completion(.success(todoData))
                    
                } else {
                    print("2")
                    return completion(.failure(.parseError))
                }
            }
    }
    
    
    
    
    // MARK: - 데이터 생성 ( Create )
    func alamoFireCreate(title: String,
                         completion: @escaping TodoListCompletion) {
        
        self.session
            .request(TodoRouter.create(title: title))
            .validate(statusCode: 200..<401)
            .responseData { result in
                guard let safeData = result.data else { return }
                
                if let datas = self.todoListParsing(data: safeData) {
                    print("***********************Create 성공***********************")
                    return completion(.success(datas))
                } else {
                    return completion(.failure(.parseError))
                }
            }
    }
    
    
    
    // MARK: - 데이터 수정, 업데이트 ( Update )
    func alamoFireUpdate(todoId: Int,
                         title: String,
                         completion: @escaping TodoListCompletion) {
        
        self.session
            .request(TodoRouter.update(todoId: todoId, title: title))
            .validate(statusCode: 200..<401)
            .responseData { result in
                guard let safeData = result.data else { return }
                
                if let datas = self.todoListParsing(data: safeData) {
                    print("***********************Update 성공***********************")
                    return completion(.success(datas))
                } else {
                    return completion(.failure(.parseError))
                }
            }
    }
    
    
    // MARK: - 데이터 삭제 ( Delete )
    func alamoFireDelete(todoId: Int,
                   completion: @escaping TodoListCompletion) {
        
        self.session
            .request(TodoRouter.delete(todoId: todoId))
            .validate(statusCode: 200..<401)
            .responseData { result in
                guard let safeData = result.data else { return }

                if let datas = self.todoListParsing(data: safeData) {
                    print("***********************Delete 성공***********************")
                    return completion(.success(datas))
                } else {
                    return completion(.failure(.parseError))
                }
            }
    }
}
