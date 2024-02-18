//
//  BoardCommentViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/6/24.
//

import UIKit
import KeychainSwift
import SnapKit

class BoardCommentViewController: UIViewController {
    
    
    private lazy var tableView = UITableView()
    private let keychain = KeychainSwift()
    private var filteredComments: [DisplayComment]!
    private let bottomView = UIView()
    private let commentTextField = UITextField()
    private let sendButton = UIButton()
    var comments = [DisplayComment]()
    var isInfiniteScroll = true
    var offset = 0
    var postId: Int?
//    let shadowPath = UIBezierPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllComment(boardId: postId ?? 1, page: 0)
        setNavigate()
        setUI()
        setLayout()
        setRegister()
        setDelegate()
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyBoardObserver()
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUI() {
        view.backgroundColor = .white
//        shadowPath.do {
//            $0.move(to: CGPoint(x: 0, y: 0))
//            $0.addLine(to: CGPoint(x: view.bounds.width, y: 0))
//            $0.addLine(to: CGPoint(x: view.bounds.width, y: -5))
//            $0.addLine(to: CGPoint(x: 0, y: -5))
//            $0.close()
//        }
        tableView.do {
            $0.showsVerticalScrollIndicator = false
            $0.separatorStyle = .singleLine
        }
        bottomView.do {
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: -2)
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowRadius = 2
//            $0.layer.shadowPath = shadowPath.cgPath
        }
        commentTextField.do {
            $0.placeholder = "댓글을 남겨보세요"
            $0.setPlaceholderColor(placeholderColor: .G3())
            $0.rightView = sendButton
            $0.rightViewMode = .always
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.backgroundColor = .L1()
        }
        sendButton.do {
            $0.setTitle("등록", for: .normal)
            $0.titleLabel?.font = .pretendard(size: 13, weight: .regular)
            $0.layer.cornerRadius = 10
            $0.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.titleLabel?.numberOfLines = 1
            $0.backgroundColor = UIColor(hex: "EBEBEB")
            $0.setTitleColor(.G4(), for: .normal)
            $0.addTarget(self, action: #selector(sendButtonTapped(_: )), for: .touchUpInside)
        }
    }
    
    @objc func sendButtonTapped(_ sender: UIButton) {
        guard let comment = commentTextField.text, !comment.isEmpty else {
            print("No comment")
            return
        }
        
        // 서버에 댓글을 보내는 함수를 호출합니다.
        addComment(boardId: postId ?? 1, parentId: -1, content: comment)
        
        // 텍스트 필드의 내용을 초기화합니다.
        commentTextField.text = ""
        
        // 키보드를 내립니다.
        commentTextField.resignFirstResponder()
    }
    
    private func setRegister() {
        tableView.register(commentTableViewCell.self,
                           forCellReuseIdentifier: commentTableViewCell.identifier)
    }
    
    private func setLayout() {
        view.addSubviews(tableView, bottomView)
        bottomView.addSubview(commentTextField)
        bottomView.snp.makeConstraints {
            $0.height.equalTo(58)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        commentTextField.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(8)
        }
        tableView.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.top)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setNavigate() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(popToMainViewController))
        leftButton.tintColor = UIColor.G6()
        self.navigationItem.leftBarButtonItem = leftButton
        navigationItem.title = "댓글"
    }
    
    @objc func popToMainViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension BoardCommentViewController {
    func flattenComments(_ comments: [CommentData], level: Int) -> [DisplayComment] {
        var result = [DisplayComment]()
        
        for comment in comments {
            result.append(DisplayComment(comment: comment, level: level))
            
            // 대댓글이 있을 경우에만 재귀적으로 함수를 호출
            if let children = comment.children, !children.isEmpty {
                let replies = flattenComments(children, level: level + 1)
                result.append(contentsOf: replies)
            }
        }
        
        return result
    }
    
    func getAllComment(boardId: Int, page: Int) {
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.getAllComment(token: token, boardId: boardId, page: page) { result in
                switch result {
                case .success(let data):
                    if let data = data as? CommentDTO {
                        let serverData = data.data.content
                        var mappedData: [CommentData] = []
                        
                        for serverItem in serverData {
                            
                            let writerData = WriterData(nickName: serverItem.writer?.nickName ?? "", occupation: serverItem.writer?.occupation ?? "")
                            
                            var childrenData: [CommentData]?
                            if !serverItem.children.isEmpty {
                                childrenData = serverItem.children.map { child in
                                    let childWriterData = WriterData(nickName: child.writer?.nickName ?? "", occupation: child.writer?.occupation ?? "")
                                    return CommentData(parentId: child.parentID, commentId: child.commentID, createAt: child.createAt, content: child.content, writer: childWriterData, children: nil)
                                }
                            }
                            
                            let mappedItem = CommentData(parentId: serverItem.parentID, commentId: serverItem.commentID, createAt: serverItem.createAt, content: serverItem.content, writer: writerData, children: childrenData)
                            mappedData.append(mappedItem)
                        }
                        self.comments.append(contentsOf: self.flattenComments(mappedData, level: 0))
                        self.filteredComments = self.comments
                        
                        // 테이블 뷰 업데이트
                        self.tableView.reloadData()
                        self.isInfiniteScroll = !data.data.last
                    } else {
                                            print("Failed to decode the response.")
                                        }
                case .requestErr(let message):
                    // Handle request error here.
                    print("Request error: \(message)")
                case .pathErr:
                    // Handle path error here.
                    print("Path error")
                case .serverErr:
                    // Handle server error here.
                    print("Server error")
                case .networkFail:
                    // Handle network failure here.
                    print("Network failure")
                default:
                    break
                }
            }
        }
    }
    func addComment( boardId: Int, parentId: Int, content: String) {
        if let token = self.keychain.get("idToken") {
            print("\(token)")
            BoardAPI.shared.addComment(token: token, boardId: boardId, parentId: parentId, content: content) { result in
                switch result {
                case .success(let data):
                    if let data = data as? CommentDTO {
                        let serverData = data.data.content
                        var mappedData: [CommentData] = []
                        
                        for serverItem in serverData {
                            
                            let writerData = WriterData(nickName: serverItem.writer?.nickName ?? "", occupation: serverItem.writer?.occupation ?? "")
                            
                            var childrenData: [CommentData]?
                            if !serverItem.children.isEmpty {
                                childrenData = serverItem.children.map { child in
                                    let childWriterData = WriterData(nickName: child.writer?.nickName ?? "", occupation: child.writer?.occupation ?? "")
                                    return CommentData(parentId: child.parentID, commentId: child.commentID, createAt: child.createAt, content: child.content, writer: childWriterData, children: nil)
                                }
                            }
                            
                            let mappedItem = CommentData(parentId: serverItem.parentID, commentId: serverItem.commentID, createAt: serverItem.createAt, content: serverItem.content, writer: writerData, children: childrenData)
                            mappedData.append(mappedItem)
                        }
                        self.comments = self.flattenComments(mappedData, level: 0)
                        self.filteredComments = self.comments
                        
                        // 테이블 뷰 업데이트
                        self.tableView.reloadData()
                        self.isInfiniteScroll = !data.data.last
                    } else {
                                            print("Failed to decode the response.")
                                        }
                    print("success")
                case .requestErr(let message):
                    print("Request error: \(message)")
                    
                case .pathErr:
                    print("Path error")
                    
                case .serverErr:
                    print("Server error")
                    
                case .networkFail:
                    print("Network failure")
                    
                default:
                    break
                }
            }
        }
    }
}
    
extension BoardCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
                if isInfiniteScroll {
                    isInfiniteScroll = false
                    offset += 1
                    getAllComment(boardId: postId ?? 1, page: offset)
                }
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredComments?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: commentTableViewCell.identifier, for: indexPath) as? commentTableViewCell else {
            return UITableViewCell()
        }
        
        let comment: DisplayComment
        if indexPath.row < filteredComments.count {
            comment = filteredComments[indexPath.row]
        } else {
            comment = comments[indexPath.row]
        }
        cell.indentationWidth = 30
        cell.indentationLevel = comment.level
        cell.configureCell(comment)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension BoardCommentViewController {
    // keyboard action control
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        /// 키보드의 높이
        let keyboardHeight = keyboardFrame.size.height
        /// 댓글 입력(textField)를 포함하고 있는 View
        let commentViewHeight = 58.0
        
        bottomView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight - self.view.safeAreaInsets.bottom)
                }
        tableView.contentOffset.y = keyboardHeight + commentViewHeight
        
        UIView.animate(withDuration: 0.3,
                       animations: { self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        tableView.contentOffset.y = .zero
        tableView.scrollIndicatorInsets = self.tableView.contentInset
        bottomView.snp.updateConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(0)
            }
        
        UIView.animate(withDuration: 0.3,
                       animations: { self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    func removeKeyBoardObserver() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
}