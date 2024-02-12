//
//  EditMyProfileViewController.swift
//  CoPro
//
//  Created by 박신영 on 2/2/24.
//

import UIKit
import SnapKit
import Then
import KeychainSwift

class EditMyProfileViewController: BaseViewController, UITextFieldDelegate {
    
    private let keychain = KeychainSwift()
    
    let container = UIView()
    var languageStackView: UIStackView?
    var careerStackView: UIStackView?
    var stackViewHeightConstraint: Constraint?
    var initialUserName: String?
    var isJobsButtonTap: Bool?
    var editFlag: Bool?
    var nickNameDuplicateFlag: Bool = true
    var selectedJob: String?
    var selectedLanguageButtons = [UIButton]()
    var selectedCareer: String?
    var isNicknameModificationSuccessful: Bool?
    
    var editMyProfileBody = EditMyProfileRequestBody()
    
    
    private let nickNameLabel = UILabel().then({
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.text = "닉네임"
    })
    
    private var nicknameDuplicateCheckLabel = UILabel().then {
        $0.textColor = UIColor(red: 0.98, green: 0.161, blue: 0.145, alpha: 1)
        $0.font = .systemFont(ofSize: 11)
//        $0.font = UIFont(name: "Pretendard-Regular", size: 11)
        $0.text = "사용 가능한 닉네임입니다."
    }
    
    let nickNameTextField = UITextField().then {
        $0.placeholder = "닉네임"
        $0.clearButtonMode = .always
        $0.keyboardType = .alphabet
        $0.autocapitalizationType = .none
        $0.spellCheckingType = .no
    }
    
    let textFieldContainer = UIView().then {
        $0.layer.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.824, alpha: 1).cgColor
        $0.layer.cornerRadius = 10
    }
    
    private let languageUsedLabel = UILabel().then({
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.text = "사용 언어"
    })
    
    private let myJobLabel = UILabel().then({
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.text = "나의 직무"
    })
    
    private let careerLabel = UILabel().then({
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        $0.text = "개발 경력"
    })
    
    lazy var jobButtonsStackView = UIStackView().then { stackView in
        let buttonTitles = ["Frontend", "Backend", "Mobile", "AI"]
        let buttons = buttonTitles.map { title -> UIButton in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.layer.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.824, alpha: 1).cgColor
            button.layer.cornerRadius = 10
            button.setTitleColor(UIColor(red: 0.429, green: 0.432, blue: 0.446, alpha: 1), for: .normal)
            button.setTitleColor(UIColor.blue, for: .selected)
            button.addTarget(self, action: #selector(handleJobButtonSelection(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            return button
        }
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 11
    }
    
    lazy var nextButton = UIButton().then {
        $0.layer.backgroundColor = UIColor(.gray).cgColor
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(didNextButtonAlert), for: .touchUpInside)
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.titleLabel?.textColor = .white
    }
    
    lazy var doneButton = UIButton().then {
        $0.layer.backgroundColor = UIColor(.gray).cgColor
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(didDoneButton), for: .touchUpInside)
        $0.setTitle("선택 완료", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.titleLabel?.textColor = .white
        $0.isEnabled = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        nickNameTextField.delegate = self
        nickNameTextField.text = initialUserName
        isJobsButtonTap = false
//        getNickNameDuplication(nickname: initialUserName ?? "")
    }
    
    override func setUI() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.preferredCornerRadius = 15
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.detents = [.custom {context in
                return self.returnEditMyProfileUIHeight(type: "First")
            }]
        }
    }
    
    override func setLayout() {
        view.addSubview(container)
        container.addSubviews(nickNameLabel, textFieldContainer, nicknameDuplicateCheckLabel, myJobLabel, jobButtonsStackView, nextButton)
        textFieldContainer.addSubview(nickNameTextField)
        
        container.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-30)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
            $0.width.equalTo(45)
        }
        
        textFieldContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            $0.height.equalTo(41) //반응형으로 바꿔야함
        }
        
            nickNameTextField.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(8)
                $0.trailing.equalToSuperview().offset(-8)
            }
        
        nicknameDuplicateCheckLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldContainer.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(8)
            $0.width.equalTo(150)
        }
        
        myJobLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameDuplicateCheckLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(8)
        }
        
        jobButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(myJobLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(41)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(jobButtonsStackView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(41)
        }
    }
    
    private func postEditMyProfile() {
        if let token = self.keychain.get("idToken") {
            MyProfileAPI.shared.postEditMyProfile(token: token, requestBody: editMyProfileBody) { result in
                switch result {
                case .success(let data):
                    if let data = data as? EditMyProfileDTO {
                        if data.statusCode != 200 {
                            print("프로필 수정 실패")
                            self.faileEditProfile()
                        } else {
                            print("프로필 수정 성공")
                            self.successEditProfile()
                        }
                    }
                case .requestErr(let message):
                    // Handle request error here.
                    print("Request error: \(message)")
                case .pathErr:
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
    
    
    private func returnEditMyProfileUIHeight(type: String) -> CGFloat {
        if type == "First" {
            let screenHeight = UIScreen.main.bounds.height
            let heightRatio = 300.0 / 852.0
            let cellHeight = screenHeight * heightRatio
            return cellHeight
        }
        else {
            let screenHeight = UIScreen.main.bounds.height
            let heightRatio = 661.0 / 852.0
            let cellHeight = screenHeight * heightRatio
            return cellHeight
        }
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            print("사용자가 입력한 텍스트: \(text)")
            if text == initialUserName {
                nickNameDuplicateFlag = true
                DispatchQueue.main.async {
                    self.nicknameDuplicateCheckLabel.text = "사용 가능한 닉네임입니다."
                }
            } else {
                getNickNameDuplication(nickname: text)
            }
        }
        updateButtonState(type: "First")
        
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func setUpKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addLanguageButtonsForJobType(jobType: String) {
        let jobTypeTechnologies = [
            "Front": ["React.js", "Vue.js", "Angular.js", "TypeScript"],
            "Backend": ["Spring", "Django", "Flask", "Node.js", "Go"],
            "Mobile": ["SwiftUI", "UIKit", "Flutter", "Kotlin", "Java"],
            "AI": ["TensorFlow", "Keras", "PyTorch"]
        ]
        
        guard let technologies = jobTypeTechnologies[jobType] else { return }
        languageStackView = UIStackView().then { stackView in
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 11
            
            for technology in technologies {
                stackView.addArrangedSubview(createButton(withTitle: technology))
            }
        }
        
        DispatchQueue.main.async { [self] in
            guard let stackView = languageStackView else { return print("languageStackView failed") }
            
            container.addSubviews(languageUsedLabel, stackView)
            
            nextButton.removeFromSuperview()
            languageUsedLabel.snp.makeConstraints {
                $0.top.equalTo(jobButtonsStackView.snp.bottom).offset(18)
                $0.leading.equalToSuperview().offset(8)
                $0.width.equalTo(79)
            }
            
            stackView.snp.makeConstraints {
                $0.top.equalTo(languageUsedLabel.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(41)
            }
        }
    }
    
    @objc func handleJobButtonSelection(_ sender: UIButton) {
        for subview in jobButtonsStackView.arrangedSubviews {
            if let button = subview as? UIButton {
                button.isSelected = false
                button.layer.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.824, alpha: 1).cgColor
            }
        }
        isJobsButtonTap = true
        sender.isSelected = true
        sender.layer.backgroundColor = UIColor(red: 0.71, green: 0.769, blue: 0.866, alpha: 1).cgColor
        selectedJob = sender.currentTitle
        updateButtonState(type: "First")
    }
    
    @objc func handleLanguageButtonSelection(_ sender: UIButton) {
        if selectedLanguageButtons.count < 2 {
            // 선택된 버튼이 2개 미만일 때
            sender.isSelected = true
            sender.layer.backgroundColor = UIColor(red: 0.71, green: 0.769, blue: 0.866, alpha: 1).cgColor
            selectedLanguageButtons.append(sender)
        } else {
            // 선택된 버튼이 이미 2개일 때
            let firstButton = selectedLanguageButtons.removeFirst()   // 첫 번째로 선택된 버튼을 제거
            firstButton.isSelected = false
            firstButton.layer.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.824, alpha: 1).cgColor
            
            sender.isSelected = true
            sender.layer.backgroundColor = UIColor(red: 0.71, green: 0.769, blue: 0.866, alpha: 1).cgColor
            selectedLanguageButtons.append(sender)   // 새로 선택된 버튼을 추가
        }
        updateButtonState(type: "End")
    }
    
    @objc func handleCareerButtonSelection(_ sender: UIButton) {
        guard let careerStackView = careerStackView else {return print("careerStackView error")}
        for subview in careerStackView.arrangedSubviews {
            if let button = subview as? UIButton {
                button.isSelected = false
                button.layer.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.824, alpha: 1).cgColor
            }
        }
        sender.isSelected = true
        sender.layer.backgroundColor = UIColor(red: 0.71, green: 0.769, blue: 0.866, alpha: 1).cgColor
        selectedCareer = sender.currentTitle
        updateButtonState(type: "End")
    }

    
    func updateButtonState(type: String) {
        if type == "First" {
            let isTextFieldNotEmpty = nickNameTextField.text?.isEmpty == false
            let isSelectedJobNotEmpty = selectedJob?.isEmpty == false
            DispatchQueue.main.async { [self] in
                if isTextFieldNotEmpty && isSelectedJobNotEmpty {
                    nextButton.backgroundColor = UIColor(red: 0.145, green: 0.467, blue: 0.996, alpha: 1)
                    editFlag = true
                } else {
                    nextButton.backgroundColor = .gray
                    editFlag = false
                }
            }
        } else {
            let isSelectedButtonsNotEmpty = selectedLanguageButtons.isEmpty == false
            let isSelectedCareerNotEmpty = selectedCareer?.isEmpty == false
            DispatchQueue.main.async { [self] in
                if isSelectedButtonsNotEmpty && isSelectedCareerNotEmpty {
                    doneButton.backgroundColor = UIColor(red: 0.145, green: 0.467, blue: 0.996, alpha: 1)
                    let languageArr = selectedLanguageButtons.map { $0.currentTitle ?? "" }
                    editMyProfileBody.language = languageArr.joined(separator: ",")
                    editMyProfileBody.career = convertCareerToInt(selectedCareer: selectedCareer ?? "")
                    doneButton.isEnabled = true
                } else {
                    doneButton.backgroundColor = .gray
                    doneButton.isEnabled = false
                }
            }
        }
    }
    
    func convertCareerToInt(selectedCareer: String) -> Int {
        if selectedCareer == "신입" {
            return 1
        } else if selectedCareer == "3년 미만" {
            return 2
        } else if selectedCareer == "3년 이상" {
            return 3
        } else if selectedCareer == "5년 이상" {
            return 4
        } else if selectedCareer == "10년 이상" {
            return 5
        } else {
            return 20
        }
    }

    
    
    @objc func didTapNextButton(jobType: String) {
        editMyProfileBody.nickName = nickNameTextField.text ?? ""
        editMyProfileBody.occupation = selectedJob ?? ""
        nickNameTextField.isEnabled = false
        
        DispatchQueue.main.async { [self] in
            nextButton.isHidden = true
            nickNameLabel.textColor = UIColor.gray
            nickNameTextField.textColor = UIColor.gray
            myJobLabel.textColor = UIColor.gray
            jobButtonsStackView.arrangedSubviews.forEach { view in
                if let button = view as? UIButton {
                    button.isEnabled = false
                    if button.isSelected == true {
                        button.setTitleColor(UIColor(hex: "#5D5BC1"), for: .normal)
                    }
                }
            }
            sheetPresentationController?.animateChanges { [self] in
                        self.sheetPresentationController?.detents = [.custom {context in
                            return self.returnEditMyProfileUIHeight(type: "Secound")
                        }]
                    }
        }
        addLanguageButtonsForJobType(jobType: jobType)
        addCareerButtons()
        addDoneButton()
    }
    
    
    
    func addCareerButtons() {
        careerStackView = UIStackView().then { stackView in
            let careerType = ["신입", "3년 미만", "3년 이상", "5년 이상", "10년 이상"]

            let buttons = careerType.map { title -> UIButton in
                let button = UIButton()
                button.setTitle(title, for: .normal)
                button.layer.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.824, alpha: 1).cgColor
                button.layer.cornerRadius = 10
                button.setTitleColor(UIColor(red: 0.429, green: 0.432, blue: 0.446, alpha: 1), for: .normal)
                button.setTitleColor(UIColor.blue, for: .selected)
                button.addTarget(self, action: #selector(handleCareerButtonSelection(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(button)
                return button
            }
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 11
        }
        
        DispatchQueue.main.async { [self] in
            guard let stackView = careerStackView else { return print("careerStackView failed") }
            
            container.addSubviews(careerLabel, stackView)
            
            careerLabel.snp.makeConstraints {
                $0.top.equalTo(languageStackView!.snp.bottom).offset(18)
                $0.leading.equalToSuperview().offset(8)
                $0.width.equalTo(79)
            }
            
            stackView.snp.makeConstraints {
                $0.top.equalTo(careerLabel.snp.bottom).offset(8)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(41)
            }
        }
    }
    
    func addDoneButton() {
        DispatchQueue.main.async { [self] in
            container.addSubview(doneButton)
            
            doneButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(530)
                $0.bottom.equalToSuperview().offset(-47)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
            }
        }
    }
    
    
    
    //얘 활용하기
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.backgroundColor = UIColor(red: 0.82, green: 0.82, blue: 0.824, alpha: 1).cgColor
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(red: 0.429, green: 0.432, blue: 0.446, alpha: 1), for: .normal)
        button.setTitleColor(UIColor.blue, for: .selected)
        button.addTarget(self, action: #selector(handleLanguageButtonSelection(_:)), for: .touchUpInside)
        return button
    }
    
    private func getNickNameDuplication(nickname: String) {
        if let token = self.keychain.get("idToken") {
            print("현재 nickname : \(nickname)")
            MyProfileAPI.shared.getNickNameDuplication(token: token, nickname: nickname) { result in
                print("Result: \(result)")
                switch result {
                case .success(let data):
                    print("🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊uccess🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊🌊")
                    if let data = data as? getNickNameDuplicationDTO {
                        self.nickNameDuplicateFlag = data.data
                        DispatchQueue.main.async {
                            self.nicknameDuplicateCheckLabel.text = data.message
                        }
                    } else {
                        print("Failed to decode the response.")
                    }
                    
                case .requestErr(let message):
                    // Handle request error here.
                    print("🌊🌊🌊🌊🌊🌊🌊Request error: \(message)")
                case .pathErr:
                    // Handle path error here.
                    print("🌊🌊🌊🌊🌊🌊🌊Path error")
                case .serverErr:
                    // Handle server error here.
                    print("🌊🌊🌊🌊🌊🌊🌊Server error")
                case .networkFail:
                    // Handle network failure here.
                    print("🌊🌊🌊🌊🌊🌊🌊Network failure")
                default:
                    break
                }
            }
        }
    }
    
    @objc func didDoneButton() {
        postEditMyProfile()
    }
    
    
    @objc func didNextButtonAlert() {
        if editFlag == true && nickNameDuplicateFlag == true {
            didNext()
        }
        else {
            didError()
        }
    }
    
    @objc private func didNext() {
        showAlert(title: "다음 수정을 진행하시겠습니까?",
                  message: "이후 이전 내용은 수정하실 수 없습니다." ,
                  cancelButtonName: "취소",
                  confirmButtonName: "확인",
                  confirmButtonCompletion: { [self] in
            didTapNextButton(jobType: selectedJob ?? "")
        })
    }
    
    @objc private func didError() {
        showAlert(title: "모든 필드가 유효한지 확인 및 입력해주세요.",
                  confirmButtonName: "확인")
    }
    
    private func successEditProfile() {
        showAlert(title: "프로필 수정을 완료하였습니다.",
                  confirmButtonName: "확인",
                  confirmButtonCompletion: { [self] in
            // 먼저 열린 창을 닫기
                    self.navigationController?.popViewController(animated: true)
                    // 그 다음 모달을 닫기
                    self.dismiss(animated: true, completion: nil)
        })
    }
    
    private func faileEditProfile() {
        showAlert(title: "프로필 수정을 실패하였습니다.",
                  confirmButtonName: "확인",
                  confirmButtonCompletion: { [self] in
            // 먼저 열린 창을 닫기
                    self.navigationController?.popViewController(animated: true)
                    // 그 다음 모달을 닫기
                    self.dismiss(animated: true, completion: nil)
        })
    }

    
    /* textField의 값 변경을 바로바로 감지해주는 친구
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
     */
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
            if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}


