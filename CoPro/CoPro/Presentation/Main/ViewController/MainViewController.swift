//
//  MainViewController.swift
//  CoPro
//
//  Created by 문인호 on 11/13/23.
//

import UIKit

import SnapKit
import Then

final class MainViewController: UIViewController {
    
    //MARK: - UI Components
    private let recruitVC = recruitViewController()
    let grabberView = UIView()
    private var backgroundView = UIView()
    private lazy var noticeBoardView = UIView()
    let halfHeight = UIScreen.main.bounds.height / 2
    let fullHeight = UIScreen.main.bounds.height
    var panGesture = UIPanGestureRecognizer()
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    var images: [UIImage] = [UIImage(named: "bird")!, UIImage(named: "plant")!, UIImage(named: "fruit")!] // 사용할 이미지들
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UnderlineSegmentedControl(items: ["모집", "자유", "공지사항"])
      segmentedControl.translatesAutoresizingMaskIntoConstraints = false
      return segmentedControl
    }()

    private let vc2: UIViewController = {
      let vc = UIViewController()
      vc.view.backgroundColor = .cyan
      return vc
    }()
    private let vc3: UIViewController = {
      let vc = UIViewController()
      vc.view.backgroundColor = .yellow
      return vc
    }()
    private lazy var pageViewController: UIPageViewController = {
      let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
      vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
      vc.delegate = self
      vc.dataSource = self
      vc.view.translatesAutoresizingMaskIntoConstraints = false
      return vc
    }()
      
    var dataViewControllers: [UIViewController] {
        [recruitVC, self.vc2, self.vc3]
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
      }
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setRegister()
        setGesture()
        setDelegate()
        setNavigate()
        setAddTarget()
        setupScrollView()
        setupPageControl()
        view.bringSubviewToFront(noticeBoardView)
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
                NSAttributedString.Key.foregroundColor: UIColor(hex: "#2577FE"),
                .font: UIFont.systemFont(ofSize: 17)
              ],
              for: .selected
            )
        }
        noticeBoardView.do {
            $0.backgroundColor = .white
        }
        grabberView.do {
            $0.backgroundColor = .red
            $0.layer.cornerRadius = 2.5
        }
        pageViewController.do {
            $0.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
            $0.dataSource = self
            $0.view.translatesAutoresizingMaskIntoConstraints = false
        }
        segmentedControl.do {
            $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "#6D6E72"), .font: UIFont.systemFont(ofSize: 13, weight: .bold)], for: .normal)
            $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "#2577FE"),.font: UIFont.systemFont(ofSize: 13, weight: .bold)],for: .selected)
            $0.selectedSegmentIndex = 0
        }
        self.changeValue(control: self.segmentedControl)
    }
    private func setNavigate() {
        let logoImage = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        let leftButton = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: #selector(popToWriteViewController))
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(button2Tapped))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
    }   
    private func setLayout() {
        view.addSubviews(noticeBoardView, scrollView, pageControl)
        
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
        noticeBoardView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom)
            $0.height.equalTo(300)
            $0.width.equalTo(UIScreen.main.bounds.width)
        }

        noticeBoardView.addSubviews(grabberView ,segmentedControl, pageViewController.view)
        grabberView.snp.makeConstraints {
            $0.top.equalTo(noticeBoardView.snp.top)
            $0.height.equalTo(5)
            $0.width.equalTo(UIScreen.main.bounds.width - 30)
            $0.centerX.equalToSuperview()
        }
        segmentedControl.snp.makeConstraints {
            $0.leading.equalTo(noticeBoardView.snp.leading).offset(16)
            $0.trailing.equalTo(noticeBoardView.snp.trailing).offset(-16)
            $0.top.equalTo(noticeBoardView.snp.top).offset(10)
            $0.height.equalTo(50)

        }
        pageViewController.view.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.bottom.equalToSuperview().offset(-4)
            $0.top.equalTo(segmentedControl.snp.bottom).offset(5)
        }
    }
    private func setDelegate() {
        pageViewController.delegate = self
        scrollView.delegate = self
    }
    private func setRegister() {

    }
    private func setGesture(){
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureHandler))
        self.grabberView.addGestureRecognizer(panGesture)
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

//    // MARK: - @objc Method

    @objc func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let maxHeight = view.frame.size.height - navigationController!.navigationBar.frame.size.height - UIApplication.shared.statusBarFrame.height

        if recognizer.state == .changed {
            let newY = max(self.noticeBoardView.frame.origin.y + translation.y, 0)
            self.noticeBoardView.frame.origin.y = newY
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        else if recognizer.state == .ended {
            if self.noticeBoardView.frame.origin.y < halfHeight {
                openDrawer()
            }
            else {
                closeDrawer()
            }
        }
    }
    func openDrawer() {
            // 뷰의 높이를 전체 높이로 설정
        noticeBoardView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: fullHeight)
            
            // 애니메이션 적용
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        func closeDrawer() {
            // 뷰의 높이를 절반 높이로 설정
            noticeBoardView.frame = CGRect(x: 0, y: halfHeight, width: view.frame.width, height: halfHeight)
            
            // 애니메이션 적용
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    @objc private func changeValue(control: UISegmentedControl) {
      // 코드로 값을 변경하면 해당 메소드 호출 x
      self.currentPage = control.selectedSegmentIndex
    }
    
    @objc func popToWriteViewController() {
        // 'Button 1'이 눌렸을 때의 동작을 여기에 작성합니다.
    }

    @objc func button2Tapped() {
        // 'Button 2'이 눌렸을 때의 동작을 여기에 작성합니다.
    }
}
    
