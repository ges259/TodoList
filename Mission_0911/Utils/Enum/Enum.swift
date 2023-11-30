//
//  Enum.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/12.
//

import UIKit

//  OptionView
enum OptionViewEnum: CustomStringConvertible {
    case delete
    case modify
    case create
    /** done 버튼의 Text*/
    var description: String {
        switch self {
        case .delete: return "삭제"
        case .modify: return "수정"
        case .create: return "생성"
        }
    }
    /** done버튼의 background_Color*/
    var doneBtnBackgroundColor: UIColor {
        switch self {
        case .delete: return UIColor.red
        case .modify: return UIColor.orange
        case .create: return UIColor.blue
        }
    }
    /** optionView의 타이틀 Text*/
    var titleLabelText: String {
        switch self {
        case .delete: return "해당 할일을 삭제하시겠습니까?"
        case .modify: return "수정할 할일을 입력하세요!"
        case .create: return "생성할 할일을 입력하세요!"
        }
    }
}
// Network_Manager
enum NetWorkError: Error, CustomStringConvertible {
    case urlError
    case netWorkError
    case dataError
    case parseError
    case badResponse
    case unknown(Error)
    case unauthorized
    case NoSearchResult
    
    var description: String {
        switch self {
        case .urlError: return ""
        case .netWorkError: return "네트워크 오류.. 다시 시도해 주세요"
        case .dataError: return "데이터 오류.. 다시 시도해 주세요"
        case .parseError: return "오류.. 다시 시도해 주세요"
        case .badResponse: return "오류.. 다시 시도해 주세요"
        case .unknown(_): return "알 수 없는 오류. 다시 시도해 주세요"
        case .unauthorized: return ""
        case .NoSearchResult: return "검색 결과가 없습니다."
        }
    }
}


// FontName
enum FontStyle {
    case system
    case bold
}
