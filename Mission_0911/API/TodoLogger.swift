//
//  TodoLogger.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/18.
//

import Foundation
import Alamofire

final class TodoLogger: EventMonitor {
    // 직렬 큐 만들기
    let queue: DispatchQueue = DispatchQueue(label: "Todo")
    
    /*
     [Request] ~~~
     ~~~
     ~~~
     -> 즉 request가 시작(Resume)되면 호출.
     */
    
    // MARK: - request가 시작되면
    func requestDidResume(_ request: Request) {
        print("TodoLogger - \(#function)")
    }
    
    
    
    
    
    
    
    // MARK: - request가 실패하면
    func request(_ request: Request, didFailTask task: URLSessionTask, earlyWithError error: AFError) {
        print("URLSessionTask가 Fail 했습니다.")
    }
    
    func request(_ request: Request, didFailToCreateURLRequestWithError error: AFError) {
        print("URLRequest를 만들지 못했습니다.")
    }
    
    func requestDidCancel(_ request: Request) {
        print("request가 cancel 되었습니다")
    }
    
    
    
    
    
    
    
    // MARK: - request가 끝난 직후
    func requestDidFinish(_ request: Request) {
        print("----------------------------------------------------\n\n" + "              🛰 NETWORK Reqeust LOG\n" + "\n----------------------------------------------------")
        print("1️⃣ URL / Method / Header" + "\n" + "URL: " + (request.request?.url?.absoluteString ?? "")  + "\n"
              + "Method: " + (request.request?.httpMethod ?? "") + "\n"
              + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])")
        print("----------------------------------------------------\n2️⃣ Body")
//        if let body = request.request?.httpBody?.toPrettyPrintedString {
//            print("Body: \(body)")
//        } else { print("보낸 Body가 없습니다.")}
        print("----------------------------------------------------\n")
        print("\n")
        print("\n")
    }
    
    
    /*
     [Response] ~~~
     ~~~
     ~~~
     -> parse를 끝내면 Status를 받음
     */
    
    // MARK: - parse가 끝나면
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        // status코드를 받음
        guard let statusCode = request.response?.statusCode else { return }
        
        print("MyLogger - \(#function) --- statusCode: \(statusCode)")
    }
}
