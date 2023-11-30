//
//  OptionView.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/12.
//

import UIKit

final class OptionView: UIView {
    
    // MARK: - Properties
    var delegate: OptionViewDelegate?
    
    var optionEnum: OptionViewEnum = .create
    
    var todoId: Int?
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Layout
    private lazy var clearView: UIView = UIView().configView(color: UIColor.lightGray.withAlphaComponent(0.45))
        
    private let stvBackgroundView: UIView = UIView().configView(color: UIColor.white,
                                                                borderColor: UIColor.lightGray,
                                                                borderWidth: 0.5)

    private let titleLabel: PaddingLabel = PaddingLabel().PaddingOptionLabel()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
            tf.placeholder = "빡코딩하기"
            tf.backgroundColor = .systemGray5
            tf.font = UIFont.boldSystemFont(ofSize: 14)
        return tf
    }()
    
    
    private lazy var cancelBtn: CustomImgButton = {
        let btn = CustomImgButton().configCustomButton(title: "취소",
                                                       fontName: .bold,
                                                       fontSize: 16,
                                                       backgroundColor: .systemGray4)
            btn.delegate = self
        return btn
    }()
    

    private lazy var doneBtn: CustomImgButton = {
        let btn = CustomImgButton().configCustomButton(fontName: .bold,
                                                       fontSize: 16)
            btn.delegate = self
        return btn
    }()
    
    
    
    
    
    
    private lazy var horizontalStackView: UIStackView = UIStackView().stackView(
        arrangedSubviews: [self.cancelBtn,
                           self.doneBtn],
        axis: .horizontal,
        spacing: 10,
        alignment: .center,
        distribution: .fillEqually)
    
    private lazy var verticalStackView: UIStackView = UIStackView().stackView(
        arrangedSubviews: [self.titleLabel,
                           self.textField,
                           self.horizontalStackView],
        axis: .vertical,
        spacing: 15,
        alignment: .fill,
        distribution: .fill)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureAction()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure_UI
    /// optionView의 AutoLayout을 설정하는 메서드
    private func configureUI() {
        // [Auto_Layout]
        // textField
        self.textField.setTextFieldPadding(8)
        self.textField.anchorHeightAndCorner(height: 40, cornerRadius: 8)
        // titleLabel
        self.titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        // cancelBtn
        self.cancelBtn.anchorHeightAndCorner(height: 40, cornerRadius: 8)
        // doneBtn
        self.doneBtn.anchorHeightAndCorner(height: 40, cornerRadius: 8)
        // clearView
        self.addSubview(self.clearView)
        self.clearView.anchor(top: self.topAnchor,
                              bottom: self.bottomAnchor,
                              leading: self.leadingAnchor,
                              trailing: self.trailingAnchor)
        
        // stvBackgroundView
        self.addSubview(self.stvBackgroundView)
        self.stvBackgroundView.anchor(width: 250, height: 185,
                                      centerX: self,
                                      centerY: self, paddingCenterY: -40,
                                      cornerRadius: 8)
        
        // stvBackgroundView
        self.stvBackgroundView.addSubview(self.verticalStackView)
        // verticalStackView
        self.verticalStackView.anchor(width: 220, height: 140,
                                      centerX: self.stvBackgroundView,
                                      centerY: self.stvBackgroundView)
    }
    
    
    
    /// selector와 Gestrue를 설정하는 메서드
    private func configureAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleClearViewTapped))
        self.clearView.addGestureRecognizer(tap)
        
        self.cancelBtn.addTarget(self, action: #selector(self.handleCancelBtnTapped), for: .touchUpInside)
        self.doneBtn.addTarget(self, action: #selector(self.handleDoneBtnTapped), for: .touchUpInside)
    }
    
    
    /// done 버튼 클릭 후 실패했을 때 호출 됨
    private func handleError(_ error: Error) {
        if error is NetWorkError {
            let apiError = error as! NetWorkError
            
            self.titleLabel.attributedText = NSMutableAttributedString().attributedText(text: apiError.description)
            
            switch apiError {
            case .netWorkError:
                print("네트워크 에러")
            case .dataError:
                print("데이터 에러")
            case .parseError:
                print("parse 에러")
            case .badResponse:
                print("response 에러")
            case .urlError:
                print("URL Error")
            case .unknown(let error):
                print("알 수 없는 에러 --- \(error)")
            case .unauthorized:
                print("error---")
            case .NoSearchResult:
                print("검색 결과가 없습니다.")
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Helper_Functions
    func configureOptionView(optionEnum: OptionViewEnum, todoData: Todo? = nil) {
        // 기본 설정
        self.optionEnum = optionEnum
        self.titleLabel.textColor = UIColor.black
        // optionEnum에 따라 설정
        self.doneBtn.backgroundColor = optionEnum.doneBtnBackgroundColor
        self.doneBtn.setTitle(optionEnum.description, for: .normal)
        self.titleLabel.text = optionEnum.titleLabelText
        
        // 수정버튼 또는 삭제버튼을 클릭했을 경우 -> todoData를 전달 받음
        if let todoData = todoData {
            self.todoId = todoData.id
            self.textField.text = todoData.title
            
        // 전달 받은 todoData가 없다면 ( 추가 )
        } else  {
            self.textField.text = nil
        }
        
        
        if optionEnum == .delete {
            self.textField.isEnabled = false
        } else {
            self.textField.isEnabled = true
            self.textField.becomeFirstResponder()
        }
    }
    
    
    
    

    
    
    // MARK: - Selectors
    @objc private func handleCancelBtnTapped() {
        self.textField.resignFirstResponder()
        self.delegate?.cancelButtonTapped()
    }
    
    
    
    @objc private func handleClearViewTapped() {
        self.textField.resignFirstResponder()
    }
    
    
    
    @objc private func handleDoneBtnTapped() {
        // textField에 text가 빈칸이라면 -> return
        guard textField.text?.isEmpty == false else  {
            self.titleLabel.attributedText = NSMutableAttributedString().attributedText(text: "생성할 할 일은 입력하세요!")
            return
        }
        // 키보드 내리기
        self.textField.resignFirstResponder()
        
        
        // 버튼 Action
        switch self.optionEnum {
        case .delete:
            guard let id = self.todoId else { return } // 옵셔널 바인딩
            
            TodoAPIManager.shared.alamoFireDelete(todoId: id) { [weak self] result in
                switch result {
                case .success(let data):
                    // Delegate
                    self?.delegate?.doneButtonTapped(optionEnum: self!.optionEnum,
                                                     todoData: data)
                    
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            break
            
            
        case .modify:
            guard let text = self.textField.text,
                  let id = self.todoId else { return } // 옵셔널 바인딩
            TodoAPIManager.shared.alamoFireUpdate(todoId: id,
                                                  title: text) { [weak self] result in
                switch result {
                case .success(let data):
                    // Delegate
                    self?.delegate?.doneButtonTapped(optionEnum: self!.optionEnum,
                                                     todoData: data)
                    
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            break
            
            
        case .create:
            guard let text = self.textField.text else { return } // 옵셔널 바인딩
            
            TodoAPIManager.shared.alamoFireCreate(title: text) { [weak self] result in
                switch result {
                case .success(let data):
                    // Delegate
                    self?.delegate?.doneButtonTapped(optionEnum: self!.optionEnum,
                                                     todoData: data)
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            }
            break
        }
    }
}






// MARK: - CustomImgButtonDelegate
extension OptionView: CustomImgButtonDelegate {
    func didChangeHiglighted(currentButton: UIButton, highlighed: Bool) {
        if currentButton == cancelBtn {
            currentButton.backgroundColor = highlighed == true
            ? UIColor.systemGray3
            : UIColor.systemGray4
            
            
        } else {
            currentButton.backgroundColor = highlighed == true
            ? self.optionEnum.doneBtnBackgroundColor.withAlphaComponent(0.7)
            : self.optionEnum.doneBtnBackgroundColor
        }
    }
}

