//
//  MainFloatingViewController.swift
//  CoPro
//
//  Created by 문인호 on 3/14/24.
//

import UIKit

class MainFloatingViewController: UIViewController {
    
    // MARK: - UI Componenets
    
    private let recruitVC = recruitViewController()
    private let freeVC = freeViewController()
    private let noticeVC = noticeViewController()
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
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        setAddTarget()
    }
}
extension MainFloatingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - UI Components Property
    
    private func setLayout() {
        view.addSubviews(segmentedControl, pageViewController.view)
                segmentedControl.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.top.equalToSuperview().offset(10)
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
        recruitVC.delegate = self
        freeVC.delegate = self
        noticeVC.delegate = self
    }
    private func setAddTarget() {
        self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        self.changeValue(control: self.segmentedControl)
    }
    private func setUI() {
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
}

extension MainFloatingViewController: RecruitVCDelegate, DetailViewControllerDelegate {
    
    func didDeletePost() {
        if let currentViewController = pageViewController.viewControllers?.first as? DetailViewControllerDelegate {
            currentViewController.didDeletePost()
        }
    }
    
    func didSelectItem(withId id: Int) {
        let detailVC = DetailBoardViewController()
        detailVC.postId = id
        detailVC.delegate = self
        print("hello")
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
