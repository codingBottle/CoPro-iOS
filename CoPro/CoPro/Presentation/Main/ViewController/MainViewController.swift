//
//  MainViewController.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import FloatingPanel
import UIKit

import SnapKit
import Then

final class MainViewController: UIViewController, FloatingPanelControllerDelegate {
    
    //MARK: - UI Components
    var fpc = FloatingPanelController()
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    var images: [UIImage] = [UIImage(named: "main_slider_image1")!, UIImage(named: "main_slider_image1")!, UIImage(named: "main_slider_image1")!] // 사용할 이미지들
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setRegister()
        setDelegate()
        setNavigate()
        setupScrollView()
        setupPageControl()
        setLayout()
    }
}

extension MainViewController: UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    // MARK: - UI Components Property

    private func setUI() {
        self.view.backgroundColor = UIColor.systemBackground
        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        fpc.do {
            $0.delegate = self
            let contentVC = MainFloatingViewController()
            $0.set(contentViewController: contentVC)
//            $0.track(scrollView: contentVC.dataViewControllers[currentPage].tableView)
            $0.addPanel(toParent: self)
            $0.layout = MyFloatingPanelLayout()
        }
    }
    private func setNavigate() {
        let logoImage = UIImage(named: "logo_navigation")?.withRenderingMode(.alwaysOriginal)
        let leftButton = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: #selector(popToWriteViewController))
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(pushToSearchBarViewController))
        rightButton.tintColor = UIColor.systemGray
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
    }
    private func setLayout() {
        self.view.addSubview(fpc.view)
        // REQUIRED. It makes the floating panel view have the same size as the controller's view.
        fpc.view.frame = self.view.bounds
        fpc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          fpc.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
          fpc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
          fpc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
          fpc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        ])
        // Add the floating panel controller to the controller hierarchy.
        self.addChild(fpc)

        // Show the floating panel at the initial position defined in your `FloatingPanelLayout` object.
        fpc.show(animated: true) {
            // Inform the floating panel controller that the transition to the controller hierarchy has completed.
            self.fpc.didMove(toParent: self)
        }
    }
    private func setDelegate() {
        scrollView.delegate = self
    }
    private func setRegister() {

    }
    func setupScrollView() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let padding: CGFloat = 20

        scrollView.isPagingEnabled = true
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 2.3)
        print("rkskekfkek")
        print(scrollView.frame)
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = images[i]
            imageView.contentMode = .scaleToFill
            imageView.backgroundColor = .white

            let xPos = scrollView.frame.width * CGFloat(i) + padding
            imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.frame.width - 2 * padding, height: scrollView.frame.height)
            imageView.layer.cornerRadius = 10 // radius 설정
            imageView.layer.masksToBounds = true // 라운드 테두리 적용

            // 탭 제스처 추가
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.isUserInteractionEnabled = true
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
        }
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(screenHeight / 2.3)
        }

    }
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        // 이미지를 탭했을 때 실행할 코드
        // 여기서는 Safari를 열도록 합니다.
        
        guard let tappedImageView = sender.view as? UIImageView else { return }
        // Safari 열기
        if let url = URL(string: "https://forms.gle/3ALSbyx6QN9KNC7r5") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }


    func setupPageControl() {
        let screenHeight = UIScreen.main.bounds.height
//        pageControl.frame = CGRect(x: 0, y: screenHeight / 2, width: self.view.frame.width, height: 50)
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(page)
    }

    // MARK: - @objc Method

    @objc func popToWriteViewController() {
        // 'Button 1'이 눌렸을 때의 동작을 여기에 작성합니다.
    }

    @objc func pushToSearchBarViewController() {
        let secondViewController = SearchBarViewController()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}
    
extension MainViewController: RecruitVCDelegate {
    func didSelectItem(withId id: Int) {
            let detailVC = DetailBoardViewController()
            detailVC.postId = id
            print("hello")
            navigationController?.pushViewController(detailVC, animated: true)
        }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.4, edge: .bottom, referenceGuide: .superview),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 44.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}
