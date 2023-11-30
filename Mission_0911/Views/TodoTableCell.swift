//
//  TodoTableCell.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/11.
//

import UIKit

final class TodoTableCell: UITableViewCell {
    
    // MARK: - Properties
    var delegate: TodoCellDelegate?
    
    
    var todoData: Todo? { didSet { self.configureCell() } }
    
    
    // MARK: - Layout
    private let todoTitleLabel: PaddingLabel = PaddingLabel().configurePaddingLbl()
    
    private lazy var modifyBtn: CustomImgButton = {
        let btn = CustomImgButton().buttonCustemImage(imageString: "square.and.pencil")
            btn.delegate = self
        return btn
    }()
    
    private lazy var deleteBtn: CustomImgButton = {
        let btn = CustomImgButton().buttonCustemImage(imageString: "trash")
            btn.delegate = self
        return btn
    }()
            
    
    
    
    
    
    
    
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureUI()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - configure_UI
    // 테이블뷰셀 기본 설정
        // 오토레이아웃
    private func configureUI() {
        // selection_Style
        self.selectionStyle = .none
        
        // Add_SubView
        self.addSubview(self.todoTitleLabel)
        self.contentView.addSubview(self.modifyBtn)
        self.contentView.addSubview(self.deleteBtn)
        
        // [Auto_Layout]
        self.modifyBtn.translatesAutoresizingMaskIntoConstraints = false
        self.todoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.deleteBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.deleteBtn.widthAnchor.constraint(equalToConstant: 50),
            self.deleteBtn.heightAnchor.constraint(equalToConstant: 50),
            self.deleteBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.modifyBtn.trailingAnchor.constraint(equalTo: self.deleteBtn.leadingAnchor, constant: -6),
            self.modifyBtn.widthAnchor.constraint(equalToConstant: 50),
            self.modifyBtn.heightAnchor.constraint(equalToConstant: 50),
            self.modifyBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.todoTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.todoTitleLabel.trailingAnchor.constraint(equalTo: self.modifyBtn.leadingAnchor, constant: -6),
            self.todoTitleLabel.heightAnchor.constraint(equalToConstant: 50),
            self.todoTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func configureAction() {
        self.modifyBtn.addTarget(self, action: #selector(self.handleModifyTapped), for: .touchUpInside)
        self.deleteBtn.addTarget(self, action: #selector(self.handleDeleteTapped), for: .touchUpInside)
    }
    
    private func configureCell() {
        guard let todoData = self.todoData else { return }
        self.todoTitleLabel.text = todoData.title
        
        let color:  UIColor = todoData.isDone == true
        ? .systemGray4
        : .white
        
        self.todoTitleLabel.backgroundColor = color
        self.modifyBtn.backgroundColor = color
        self.deleteBtn.backgroundColor = color
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Selectors
    @objc private func handleModifyTapped() {
        guard let todoData = self.todoData else { return }
        self.delegate?.cellBtnTapped(cell: self, optionEnum: .modify, todoData: todoData)
    }
    @objc private func handleDeleteTapped() {
        guard let todoData = self.todoData else { return }
        self.delegate?.cellBtnTapped(cell: self, optionEnum: .delete, todoData: todoData)
    }
}










// MARK: - CustomImgButtonDelegate
extension TodoTableCell: CustomImgButtonDelegate {
    // 버튼을 클릭했을 때 반응
    func didChangeHiglighted(currentButton: UIButton, highlighed: Bool) {
        if todoData?.isDone == true {
            currentButton.backgroundColor = highlighed == true
            ? UIColor.systemGray5
            : .systemGray4
            
        }  else  {
            currentButton.backgroundColor = highlighed == true
            ? UIColor.systemGray5
            : UIColor.white
        }
    }
}
