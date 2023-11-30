//
//  Network.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/12.
//

import UIKit

// MARK: - TodoData
struct TodoData: Codable {
    let todoResults: [Todo]?
    let meta: Meta?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case todoResults = "data"
        case meta
        case message
    }
}
// MARK: - Todo
struct Todo: Codable {
    let id: Int?
    let title: String?
    let isDone: Bool?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case isDone = "is_done"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
// MARK: - Meta
struct Meta: Codable {
    let currentPage, from, lastPage, perPage: Int?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case perPage = "per_page"
        case to, total
    }
}


// MARK: - Todo
struct TodoList: Codable {
    let data: Todo?
}
