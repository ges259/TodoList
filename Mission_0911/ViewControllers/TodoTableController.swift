//
//  TodoTableView.swift
//  Mission_0911
//
//  Created by 계은성 on 2023/09/11.
//

import UIKit

final class TodoTableController: UIViewController {
    
    // MARK: - Properties
    // 처음 화면 테이블뷰의 데이터들
    private var todoDatas = [Todo]()
    // 서치바에 데이터를 검색했을 때 검색 결과 데이터들
    private var searchTodoDatas: [Todo] = []
    
    
    private var searchMode: Bool = false
    private var searchTerm: String = " "
    
    
    private var mainPage: Int = 0
    private var searchPage: Int = 0
    
    /** 셀의 버튼을 눌렀을 때(수정 또는 삭제 버튼) -> 인덱스를 알 수 있는 변수 */
    private var indexPath: IndexPath?
    
    private let refresher: UIRefreshControl = UIRefreshControl()
    
    /** 서치바를 클릭하면 -> 해당 상수의 크기만큼 서치바 옆 취소버튼의 frame 변경*/
    private let cancelBtnFrameChange: CGFloat = 58
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Layout
    /** 테이블뷰 */
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.delegate = self
            tableView.dataSource = self
        // 키보드가 나와있는 상태에서 테이블뷰를 드래그하면 키보드 내려감
            tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    
    
    /** 서치바 */
    private lazy var searchBar: CustomSearchBar = {
        let frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 50)
        var searchBar = CustomSearchBar(frame: frame)
            searchBar.delegate = self
            searchBar.placeholder = "할일을 검색해 보세요"
            searchBar.autocapitalizationType = .none
            searchBar.autocorrectionType = .no
            searchBar.searchBarStyle = .minimal
            searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16)
        let searchBarStyle = searchBar.value(forKey: "searchField") as? UITextField
            searchBarStyle?.clearButtonMode = .never
        return searchBar
    }()
    
    
    
    /** 서치바 옆 취소 버튼 */
    private lazy var cancelBtn: CustomImgButton = {
        let btnFrame = CGRect(x: self.view.frame.width, y: 100, width: 50, height: 50)
        let btn = CustomImgButton(frame: btnFrame)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            btn.setImage(UIImage(systemName: "multiply", withConfiguration: imageConfig), for: .normal)
            btn.tintColor = UIColor.black
            btn.layer.borderColor = UIColor.lightGray.cgColor
            btn.layer.borderWidth = 1
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 8
            btn.delegate = self
        return btn
    }()
    
    
    
    /** 추가, 수정, 삭제 창 */
    private lazy var optionView: OptionView = {
        let optionView = OptionView()
            optionView.delegate = self
            optionView.alpha = 0
        return optionView
    }()
    
    /** 바닥 인디케이터 */
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
            indicator.hidesWhenStopped = true
            indicator.color = .lightGray
        return indicator
    }()
    
    
    private let noSearchResultString: UILabel = {
        let lbl = UILabel()
            lbl.text = "검색 결과가 없습니다."
            lbl.font = UIFont.boldSystemFont(ofSize: 18)
            lbl.textColor = UIColor.black
            lbl.alpha = 0
        return lbl
    }()
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        self.fetchTodoData()
        self.configureNav()
        self.configureUI()
        self.configureAction()
        // debounce 설정
        self.debounceSearchTextField()
    }
    
    
    
    
    
    // MARK: - Configure_UI
    // 네비게이션바 설정
    private func configureNav() {
        // Navigation_Bar
        let label = UILabel()
            label.textColor = UIColor.black
            label.text = "오늘할일"
            label.font = UIFont.boldSystemFont(ofSize: 25)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        // configure_Navigation_Controller
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .done, target: self,
                                                                 action: #selector(self.handleCreate))
    }
    
    // 오토레이아웃 설정
    private func configureUI() {
        // 테이블셀 레지스터 설정
        self.tableView.register(TodoTableCell.self, forCellReuseIdentifier: Identifier.todoTableIdentifier)
        // 배경 색깔 설정
        self.view.backgroundColor = .white
        // [Auto_Layout]
        // cancelBtn && searchBar
        self.view.addSubview(self.cancelBtn)
        self.view.addSubview(self.searchBar)
        // searchBar
        self.view.addSubview(self.tableView)
        self.tableView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, paddingTop: 55,
                              bottom: self.view.bottomAnchor,
                              leading: self.view.leadingAnchor,
                              trailing: self.view.trailingAnchor)
        // optionView
        self.view.addSubview(self.optionView)
        self.optionView.anchor(top: self.view.topAnchor,
                               bottom: self.view.bottomAnchor,
                               leading: self.view.leadingAnchor,
                               trailing: self.view.trailingAnchor)
        
        self.view.addSubview(self.indicator)
        self.indicator.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10,
                              centerX: self.view)
        
        self.tableView.addSubview(self.noSearchResultString)
        self.noSearchResultString.anchor(centerX: self.tableView,
                                         centerY: self.tableView)
    }
    
    // Selector 와 Gesture 설정
    private func configureAction() {
        // 테이블뷰를 탭하면 킵보드가 내려감
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleKeyboradDismissal))
        self.tableView.addGestureRecognizer(tap)
        // cancelBtn
        self.cancelBtn.addTarget(self, action: #selector(self.handleCancel), for: .touchUpInside)
        // refresher
        self.refresher.addTarget(self, action: #selector(self.handleRefreshAndFectch), for: .valueChanged)
        self.tableView.refreshControl = self.refresher
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Helper_Functions
    /** 옵션뷰(추가, 수정, 삭제 창)이 나오게 또는 숨기는 기능을 하는 메서드 */
    private func optionViewShow(_ show: Bool) {
        if show == true {
            self.searchBar.searchTextField.resignFirstResponder()
            UIView.animate(withDuration: 0.5) {
                self.optionView.alpha = 1
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.navigationItem.leftBarButtonItem?.customView?.alpha = 0.5
            }
            
            
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self.optionView.alpha = 0
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.navigationItem.leftBarButtonItem?.customView?.alpha = 1
                }
            }
        }
    }
    
    // 디바운스 설정
    private func debounceSearchTextField() {
        self.searchBar.debounce(delay: 1) { [weak self] _ in
            if self?.searchBar.text != "" {
                self?.handleRefreshAndFectch()
            }
        }
    }
    
    /// 배열의 위치(from_Index)를 remove 후 toIndex로 위치를 옮겨주는 함수
    private func removeAndInsertArray(array: [Todo],
                                      newData: Todo,
                                      fromIndex: Int,
                                      toIndex: Int) -> [Todo] {
        var arr = array
        arr[fromIndex] = newData
        let element = arr.remove(at: fromIndex)
        arr.insert(element, at: toIndex)
        return arr
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Selectors
    /** 오른쪽 네비게이션 바의 생성 버튼을 눌렀을 때 호출*/
    @objc private func handleCreate() {
        self.searchBar.searchTextField.text = ""
        self.searchMode = false
        self.optionViewShow(true)
        self.optionView.configureOptionView(optionEnum: .create)
    }
    /** 서치바의 취소 버튼을 눌렀을 때 호출 */
    @objc private func handleCancel() {
        self.searchBar.text =  nil
        self.searchBar.resignFirstResponder()
        self.searchMode = false
        self.tableView.reloadData()
        self.cancelBtn.isHighlighted = true
    }
    /** 테이블뷰를 탭하면 키보드가 내려감*/
    @objc private func handleKeyboradDismissal() {
        self.searchBar.resignFirstResponder()
    }
    /** 다시 Fetch하는 메서드 */
    @objc private func handleRefreshAndFectch() {
        // 서치모드 일 때
        if searchMode == true {
            self.searchPage = 0
            self.fetchSearchTodoDatas()
            
        // 서치모드가 아닐 때
        } else {
            self.mainPage = 0
            self.fetchTodoData()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - API
    private func fetchTodoData() {
        if self.mainPage + 1 != 1 { self.indicator.startAnimating() }
        
        TodoAPIManager.shared.alamoFireRead(page: self.mainPage + 1) {result in
            switch result {
            case .success(let datas):
                guard let todoDatas = datas.todoResults,
                      let currentMainPage = datas.meta?.currentPage else { return }

                // 현재 페이지를 저장
                self.mainPage = currentMainPage

                // 검색 결과 데이터를 저장
                // + 리프레싱 끝내기
                    // 1페이지일 때
                    // 1페이지가 아닐 때
                if currentMainPage == 1 {
                    self.todoDatas = todoDatas
                    self.refresher.endRefreshing()
                } else {
                    self.todoDatas += todoDatas
                    self.indicator.stopAnimating()
                }
                DispatchQueue.main.async { self.tableView.reloadData() }
                break
                
                
            case .failure(let error):
                print("Error... \(error.localizedDescription)")
            }
        }
    }
    
    
    
    private func fetchSearchTodoDatas() {
        if self.searchPage + 1 == 1 { self.indicator.startAnimating() }
        
        TodoAPIManager.shared.alamoFireSearch(page: self.searchPage + 1,
                                              title: self.searchTerm) { result in
            switch result {
            case .success(let searchTodoDataModel):
                guard let searchTodoDatas = searchTodoDataModel.todoResults,
                      let currentSearchPage = searchTodoDataModel.meta?.currentPage else { return }
                self.indicator.stopAnimating()
                self.noSearchResultString.alpha = 0
                // 현재 페이지를 저장
                self.searchPage = currentSearchPage
                
                // 검색 결과 데이터를 저장
                // + 리프레싱 끝내기
                    // 1페이지일 때
                    // 1페이지가 아닐 때
                if currentSearchPage == 1 {
                    self.refresher.endRefreshing()
                    self.searchTodoDatas = searchTodoDatas
                } else {
                    self.indicator.stopAnimating()
                    self.searchTodoDatas += searchTodoDatas
                }
                
                DispatchQueue.main.async { self.tableView.reloadData() }
                break
                
                
            case .failure( let error):
                self.refresher.endRefreshing()
                self.indicator.stopAnimating()
                // MARK: - Fix
                self.searchTodoDatas.removeAll()
                self.tableView.reloadData()
                self.noSearchResultString.alpha = 1
                print("Error... \(error.localizedDescription)")
            }
        }
    }
}




















// MARK: - TableView
extension TodoTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchMode
        ? self.searchTodoDatas.count
        : self.todoDatas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.todoTableIdentifier, for: indexPath) as! TodoTableCell
        
            cell.delegate = self

            cell.todoData =  self.searchMode
            ? self.searchTodoDatas[indexPath.row]
            : self.todoDatas[indexPath.row]
        return cell
    }
}



extension TodoTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 처음에 fetchUsers()를 통해 14개의 user데이터를 가져옴.
        if self.searchMode {
            if self.searchTodoDatas.count > 12 {
                if indexPath.row == self.searchTodoDatas.count - 1 {
                    self.fetchSearchTodoDatas()
                }
            }
            
        } else {
            if self.todoDatas.count > 12 {
                // 셀을 하나씩 그리다가 12번째 셀을 그리면 ( 즉, indexPath.row가 11번째일 때 fetchTodoData() 호출 )
                if indexPath.row == todoDatas.count - 1 {
                    self.fetchTodoData()
                }
            }
        }
    }
}




















// MARK: - UISearchBar
extension TodoTableController: UISearchBarDelegate {
    // 서치 시작될 때
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.4, animations: {
            self.searchBar.frame.size.width -= self.cancelBtnFrameChange
            self.cancelBtn.frame.origin.x -= self.cancelBtnFrameChange
        })
    }
    
    // 서치가 끝날 때
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchMode = false
        self.noSearchResultString.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.searchBar.frame.size.width = self.view.frame.width
            self.cancelBtn.frame.origin.x += self.cancelBtnFrameChange
        })
        return true
    }
    
    // 서치바의 텍스트가 바뀔 때마다
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // searchText가 없다면 -> SearchController 숨기기
        if searchText == "" {
            self.noSearchResultString.alpha = 0
            self.searchMode = false
            self.tableView.reloadData()
            
        // searchText가 있다면 -> SearchController 보이게
        } else {
            self.searchTerm = searchText
            self.searchMode = true
        }
    }
}
















// MARK: - TodoCellDelegate
extension TodoTableController: TodoCellDelegate {
    // 셀에서 버튼을 눌렀을 때
        // - Modify 버튼
        // - Delete 버튼
    func cellBtnTapped(cell: TodoTableCell, optionEnum: OptionViewEnum, todoData: Todo) {
        self.optionView.configureOptionView(optionEnum: optionEnum, todoData: todoData)
        self.optionViewShow(true)
        
        self.indexPath = self.tableView.indexPath(for: cell)
    }
}



// MARK: - OptionViewDelegate
extension TodoTableController: OptionViewDelegate {
    // done버튼을 눌렀을 때
    func doneButtonTapped(optionEnum: OptionViewEnum, todoData: TodoList) {
        self.optionViewShow(false)
        guard let newTodoData = todoData.data else { return }
        
        
        switch optionEnum {
        case .modify:
            DispatchQueue.main.async {
                guard let index = self.indexPath?.row else { return }
                
                self.tableView.beginUpdates()
                
                self.todoDatas.remove(at: index)
                self.todoDatas.insert(newTodoData, at: 0)
                
                self.tableView.reloadRows(at: [IndexPath(row: 0,
                                                         section: 0),
                                               IndexPath(row: index,
                                                         section: 0)],
                                          with: .fade)
                
                self.tableView.endUpdates()
            }
            
            
        case .delete:
            DispatchQueue.main.async {
                guard let index = self.indexPath?.row else { return }
                
                self.todoDatas.remove(at: index)
                self.tableView.deleteRows(at: [IndexPath(row: index,
                                                        section: 0)],
                                          with: .automatic)
            }
            
            
        case .create:
            DispatchQueue.main.async {
//                guard let index = self.indexPath?.row else { return }
                
                self.todoDatas.insert(newTodoData, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0,
                                                         section: 0)],
                                          with: .automatic)
            }
        }
    }
    // OptionView에서 취소 버튼을 눌렀을 때
    func cancelButtonTapped() {
        self.optionViewShow(false)
    }
}





// MARK: - CustomImgButtonDelegate
extension TodoTableController: CustomImgButtonDelegate {
    // 버튼을 눌렀을 때 색깔로 반응 표시
    func didChangeHiglighted(currentButton: UIButton, highlighed: Bool) {
        currentButton.backgroundColor = highlighed == true
        ? UIColor.systemGray5
        : UIColor.white
    }
}
