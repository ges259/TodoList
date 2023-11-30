//
//  Protocol.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/12.
//
import UIKit

// TodoCell -> TodoTableController
protocol TodoCellDelegate {
    /** 셀의 버튼 (modify, delete)을 누르면 호출 ----- optionEnum으로 판단.  */
    func cellBtnTapped(cell: TodoTableCell, optionEnum: OptionViewEnum, todoData: Todo)
}

// OptionView -> TodoTableController
protocol OptionViewDelegate {
    // 완료 버튼을 누르면
    func doneButtonTapped(optionEnum: OptionViewEnum, todoData: TodoList)
    // 취소 버튼을 누르면
    func cancelButtonTapped()
}


public protocol CustomImgButtonDelegate: AnyObject {
    func didChangeHiglighted(currentButton: UIButton, highlighed: Bool)
}
