//
//  ChannelViewController.swift
//  CoPro
//
//  Created by 박신영 on 12/27/23.
//

import UIKit
import SnapKit
import FirebaseAuth
import Firebase

class ChannelVC: BaseViewController {
    lazy var channelTableView: UITableView = {
        let view = UITableView()
        view.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.className)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    var channels = [Channel]()
    private let currentUser: User
    private let channelStream = ChannelFirestoreStream()
    private var currentChannelAlertController: UIAlertController?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private var topContainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let toggleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로젝트 채팅만 보기"
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    lazy private var projectToggleSwitch: UISwitch = {
        let toggleController = UISwitch()
        toggleController.isOn = self.isProjectEnabled
        toggleController.addTarget(self, action: #selector(didToggleSwitch(_:)), for: .valueChanged)
        return toggleController
    }()

    
    private var isProjectEnabled: Bool = false {
        willSet {
            print("\n토글로 바뀌기전 willSet isProjectEnabled : \(isProjectEnabled) \n")
        }
    }
    
    private var filteredChannels: [Channel] {
        if isProjectEnabled {
            return channels.filter { $0.isProject }
        } else {
            return channels
        }
    }
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    deinit {
        channelStream.removeListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        addToolBarItems()
        setupListener()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.isToolbarHidden = false // 툴바 보이게 설정
        
    }
    
    private func configureViews() {
        
        view.addSubview(channelTableView)
        view.addSubview(titleLabel)
        view.addSubview(topContainerView)
        topContainerView.addSubview(toggleLabel)
        topContainerView.addSubview(projectToggleSwitch)
        
        topContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalToSuperview().offset(-10)
            $0.leading.equalToSuperview().offset(10) // 왼쪽 제약 추가
            $0.bottom.equalTo(topContainerView.snp.top).offset(20)  //아래쪽 제약 추가
        }
        
        toggleLabel.snp.makeConstraints {
            $0.trailing.equalTo(projectToggleSwitch.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        projectToggleSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        channelTableView.snp.makeConstraints {
            $0.top.equalTo(topContainerView.snp.bottom).offset(20)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addToolBarItems() {
        toolbarItems = [
          UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(didTapSignOutItem)),
          UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
          UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddItem))
        ]
    }
    
    private func setupListener() {
        channelStream.subscribe { [weak self] result in
            switch result {
            case .success(let data):
                self?.updateCell(to: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func didTapSignOutItem() {
        showAlert(message: "로그아웃 하시겠습니까?",
                  cancelButtonName: "취소",
                  confirmButtonName: "확인",
                  confirmButtonCompletion: {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        })
    }
    
    @objc private func didTapAddItem() {
        showAlert(title: "새로운 채널 생성",
                  cancelButtonName: "취소",
                  confirmButtonName: "확인",
                  isExistsTextField: true,
                  confirmButtonCompletion: { [weak self] in
            self?.channelStream.createChannel(with: self?.alertController?.textFields?.first?.text ?? "", isProject: true)
        })
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: channelTableView)
            if let indexPath = channelTableView.indexPathForRow(at: touchPoint) {
                // 채널 삭제를 확인하는 alert를 표시합니다.
                let alert = UIAlertController(title: "채널 삭제", message: "해당 채팅방을 나가시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "채팅방 나가기", style: .destructive, handler: { _ in
                    // 채널을 삭제합니다.
                    let channel = self.channels[indexPath.row]
                    self.channelStream.deleteChannel(channel)
                }))
                present(alert, animated: true)
            }
        }
    }
    
    @objc private func didToggleSwitch(_ sender: UISwitch) {
        isProjectEnabled = sender.isOn
        print("토글버튼 눌림! : \(isProjectEnabled)")
        // 필요한 동작 수행 (예: isProjectEnabled 값 변경에 따른 작업)
        channelTableView.reloadData()
    }
    
    // MARK: - Update Cell
    
    private func updateCell(to data: [(Channel, DocumentChangeType)]) {
        data.forEach { (channel, documentChangeType) in
            switch documentChangeType {
            case .added:
                addChannelToTable(channel)
            case .modified:
                updateChannelInTable(channel)
            case .removed:
                removeChannelFromTable(channel)
            }
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
        guard channels.contains(channel) == false else { return }
        
        channels.append(channel)
        channels.sort()
        
        guard let index = channels.firstIndex(of: channel) else { return }
        channelTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels[index] = channel
        channelTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels.remove(at: index)
        channelTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
}

extension ChannelVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.className, for: indexPath) as! ChannelTableViewCell
            cell.chatRoomLabel.text = filteredChannels[indexPath.row].name
            cell.isProject = filteredChannels[indexPath.row].isProject
            print("🔥🔥🔥🔥🔥🔥🔥🔥🔥\(cell.isProject)🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")

            cell.projectChip.isHidden = !cell.isProject
        // Long press gesture recognizer를 추가합니다.
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        cell.addGestureRecognizer(longPressGesture)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        let viewController = ChatVC(user: currentUser, channel: channel)
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}

