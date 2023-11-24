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

    private lazy var noticeBoardView = UIView()
    private let segmentedControl = UnderlineSegmentedControl(items: ["모집", "자유", "공지사항"])
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var panGesture = UIPanGestureRecognizer()
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    var images: [UIImage] = [UIImage(named: "bird")!, UIImage(named: "plant")!, UIImage(named: "fruit")!] // 사용할 이미지들
    var dataViewControllers: [UIViewController] = [recruitViewController(), freeViewController(), notiViewController()]
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
    }
}

extension MainViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    // MARK: - UI Components Property

    private func setUI() {
        self.view.backgroundColor = .white
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
        pageViewController.do {
            $0.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
            $0.dataSource = self
            $0.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    private func setNavigate() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(popToWriteViewController))
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(button2Tapped))
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.leftBarButtonItem = leftButton
    }
    private func setLayout() {
        view.addSubviews(scrollView, pageControl ,noticeBoardView)
        
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
        noticeBoardView.addSubviews(segmentedControl, pageViewController.view)

        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setDelegate() {
        pageViewController.delegate = self
    }
    private func setRegister() {

    }
    private func setGesture(){
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureHandler))
        self.noticeBoardView.addGestureRecognizer(panGesture)
    }
    private func setAddTarget() {
        self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        self.changeValue(control: self.segmentedControl)
    }
    private func setupScrollView() {
        scrollView.frame = self.view.bounds
        scrollView.delegate = self
        scrollView.isPagingEnabled = true

        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = images[i]
            imageView.contentMode = .scaleToFill
            let xPos = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: 345, height: 361)
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
        }
    }
    private func setupPageControl() {
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
        let translation = recognizer.translation(in: noticeBoardView)
        let height = self.view.frame.maxY
        let velocity = recognizer.velocity(in: self.view)
        if recognizer.state == .ended {
            if velocity.y>0{
//                openDrawer()
            }
            else {
//                closeDrawer()
            }
        }
        else{
//            if weeklyHeight<=height+translation.y && height+translation.y <= monthlyHeight{
//                self.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height+translation.y)
//                UIView.animate(withDuration: 0, animations: {
//                    self.view.layoutIfNeeded()
//                    self.calendarDrawerView.layoutIfNeeded()
//                    self.shadowView.layoutIfNeeded()
//                })
//                self.infiniteWeeklyCV.alpha = 0
//                self.infiniteWeeklyCV.alpha = (height+translation.y)/monthlyHeight
//                recognizer.setTranslation(CGPoint.zero, in: self.view)
//            }
        }
    }
//    func openDrawer(){
//        setMonthList()
//        currentIndex = findMonthlyIndexFromSelectedDate()
//
//        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: monthlyHeight)
//        infiniteMonthlyCV.performBatchUpdates({self.infiniteMonthlyCV.reloadData()}, completion: {_ in
//                                                self.infiniteMonthlyCV.contentOffset.x = self.infiniteMonthlyCV.frame.width*CGFloat(self.currentIndex)
//
//        })
////        infiniteMonthlyCV.layoutIfNeeded()
//        ///spring effect
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
//            self.view.layoutIfNeeded()
//        },
//        completion: nil)
//        UIView.animate(withDuration: 0.3, animations:{
//            self.infiniteMonthlyCV.alpha = 1
//            self.infiniteWeeklyCV.alpha = 0
//        }, completion: {_ in self.monthlyCellDidSelected()})
//        self.isCovered = true
//
//    }
//
//    func closeDrawer(){
//        setWeekList()
//        let weeklyIndex = findWeeklyIndexFromSelectedDate()
//        currentIndex = weeklyIndex
//        self.infiniteWeeklyCV.setContentOffset(CGPoint(x: self.infiniteWeeklyCV.frame.width*CGFloat(weeklyIndex), y: 0), animated: false)
//
//        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: weeklyHeight)
//        infiniteWeeklyCV.performBatchUpdates({infiniteWeeklyCV.reloadData()}, completion: { _ in
//                                                self.infiniteWeeklyCV.contentOffset.x = self.infiniteWeeklyCV.frame.width*CGFloat(self.currentIndex)
//
//        })
////        infiniteWeeklyCV.layoutIfNeeded()
//
//        ///spring effect
//        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {self.view.layoutIfNeeded()}, completion: nil)
//        UIView.animate(withDuration: 0.3){
//            self.infiniteMonthlyCV.alpha = 0
//            self.infiniteWeeklyCV.alpha = 1
//        }
//        ///오늘이면 요일 색 하얗게
//        if currentIndex == infiniteMax - 1 {
//            setWeekdayWhite()
//        }
//
//        panGesture.setTranslation(CGPoint.zero, in: self.view)
//        weeklyCellDidSelected()
//        self.isCovered = false
//    }
    
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

