//
//  MainViewController.swift
//  CoPro
//
//  Created by 문인호 on 12/27/23.
//

import UIKit

import SnapKit
import Then

final class MainViewController: UIViewController {
    
    //MARK: - UI Components
    private let recruitVC = recruitViewController()
    private let freeVC = freeViewController()
    private let noticeVC = noticeViewController()

    let grabberView = UIView()
//    private lazy var noticeBoardView = UIView()
    private let bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.bottomSheetColor = .white
        view.barViewColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        return view
    }()
    var panGesture = UIPanGestureRecognizer()
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    var images: [UIImage] = [UIImage(named: "bird")!, UIImage(named: "plant")!, UIImage(named: "fruit")!] // 사용할 이미지들
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UnderlineSegmentedControl(items: ["프로젝트", "자유", "공지사항"])
      segmentedControl.translatesAutoresizingMaskIntoConstraints = false
      return segmentedControl
    }()
    private lazy var pageViewController: UIPageViewController = {
      let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
      vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
      vc.delegate = self
      vc.dataSource = self
      vc.view.translatesAutoresizingMaskIntoConstraints = false
      return vc
    }()
    
    private lazy var addPostButton: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 91, height: 37))
        btn.backgroundColor = UIColor.P2()
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.titleLabel?.font = .pretendard(size: 17, weight: .bold)
        btn.setTitle("글쓰기", for: .normal)
        btn.contentEdgeInsets = .init(top: 0, left: 1, bottom: 0, right: 1)
        btn.imageEdgeInsets = .init(top: 0, left: -1, bottom: 0, right: 1)
        btn.titleEdgeInsets = .init(top: 0, left: 1, bottom: 0, right: -1)
        btn.clipsToBounds = true
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)

        return btn
    }()
      
    var dataViewControllers: [UIViewController] {
        [recruitVC, freeVC, noticeVC]
    }
    var currentPage: Int = 0 {
        didSet {
            // from segmentedControl -> pageViewController 업데이트
            print(oldValue, self.currentPage)
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
            switch currentPage {
            case 0:
                // currentPage가 0이면 버튼을 보이게 함
                addPostButton.isHidden = false
                // a 페이지로 이동하는 코드
                break
            case 1:
                // currentPage가 1이면 버튼을 보이게 함
                addPostButton.isHidden = false
                // b 페이지로 이동하는 코드
                break
            case 2:
                // currentPage가 2이면 버튼을 숨김
                addPostButton.isHidden = true
                break
            default:
                break
            }
        }
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setRegister()
//        setGesture()
        setDelegate()
        setNavigate()
        setAddTarget()
        setupScrollView()
        setupPageControl()
        view.bringSubviewToFront(bottomSheetView)
        view.bringSubviewToFront(addPostButton)
    }
}

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    // MARK: - UI Components Property

    private func setUI() {
        self.view.backgroundColor = .white
        scrollView.do {
            $0.showsHorizontalScrollIndicator = false
        }
        segmentedControl.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.selectedSegmentIndex = 0
            $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
            $0.setTitleTextAttributes(
              [
                NSAttributedString.Key.foregroundColor: UIColor.P2(),
                .font: UIFont.pretendard(size: 17, weight: .bold)
              ],
              for: .selected
            )
        }
        pageViewController.do {
            $0.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
            $0.dataSource = self
            $0.view.translatesAutoresizingMaskIntoConstraints = false
        }
        segmentedControl.do {
            $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.G4(), .font: UIFont.pretendard(size: 17, weight: .bold)], for: .normal)
            $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.P2(),.font: UIFont.pretendard(size: 17, weight: .bold)],for: .selected)
            $0.selectedSegmentIndex = 0
        }
        self.changeValue(control: self.segmentedControl)
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
        view.addSubviews(bottomSheetView, scrollView, pageControl)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.height.equalTo(361)
            $0.width.equalTo(345)
        }
        pageControl.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.centerX.equalTo(self.view.snp.centerX)
        }
        bottomSheetView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        bottomSheetView.addSubviews(segmentedControl, pageViewController.view)

        segmentedControl.snp.makeConstraints {
            $0.leading.equalTo(bottomSheetView.bottomSheetView.snp.leading).offset(16)
            $0.trailing.equalTo(bottomSheetView.bottomSheetView.snp.trailing).offset(-16)
            $0.top.equalTo(bottomSheetView.bottomSheetView.snp.top).offset(10)
            $0.height.equalTo(50)
        }
        pageViewController.view.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.bottom.equalToSuperview().offset(-4)
            $0.top.equalTo(segmentedControl.snp.bottom).offset(5)
        }
        view.addSubview(addPostButton)
        addPostButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-91)
            $0.width.equalTo(91)
            $0.height.equalTo(37)
        }
    }
    private func setDelegate() {
        pageViewController.delegate = self
        scrollView.delegate = self
        recruitVC.delegate = self
        freeVC.delegate = self
        noticeVC.delegate = self
    }
    private func setRegister() {

    }
    private func setAddTarget() {
        self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        self.changeValue(control: self.segmentedControl)
    }
    func setupScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: 345, height: 361) // ScrollView의 크기를 설정
        scrollView.isPagingEnabled = true

            for i in 0..<images.count {
                let imageView = UIImageView()
                imageView.image = images[i]
                imageView.contentMode = .scaleAspectFit // 이미지의 비율을 유지하면서 이미지 뷰에 맞게 조절
                imageView.backgroundColor = .white
                let xPos = scrollView.frame.width * CGFloat(i)
                imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
                scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
                scrollView.addSubview(imageView)
            }
        self.view.addSubview(scrollView)
    }

    func setupPageControl() {
        pageControl.frame = CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50)
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageControl.currentPage = Int(page)
    }

    
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
      guard
        let index = self.dataViewControllers.firstIndex(of: viewController),
        index - 1 >= 0
      else { return nil }
      return self.dataViewControllers[index - 1]
    }
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
      guard
        let index = self.dataViewControllers.firstIndex(of: viewController),
        index + 1 < self.dataViewControllers.count
      else { return nil }
      return self.dataViewControllers[index + 1]
    }
    func pageViewController(
      _ pageViewController: UIPageViewController,
      didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController],
      transitionCompleted completed: Bool
    ) {
      guard
        let viewController = pageViewController.viewControllers?[0],
        let index = self.dataViewControllers.firstIndex(of: viewController)
      else { return }
      self.currentPage = index
      self.segmentedControl.selectedSegmentIndex = index
    }

    // MARK: - @objc Method


    @objc private func changeValue(control: UISegmentedControl) {
      // 코드로 값을 변경하면 해당 메소드 호출 x
      self.currentPage = control.selectedSegmentIndex
    }
    
    @objc func popToWriteViewController() {
        // 'Button 1'이 눌렸을 때의 동작을 여기에 작성합니다.
    }

    @objc func pushToSearchBarViewController() {
        let secondViewController = SearchBarViewController()
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    @objc func addButtonDidTapped() {
        switch currentPage {
            case 0:
            let addPostVC = AddProjectPostViewController()
                let navigationController = UINavigationController(rootViewController: addPostVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                break            case 1:
            let addPostVC = AddPostViewController()
                let navigationController = UINavigationController(rootViewController: addPostVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                break
            default:
                break
            }
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
