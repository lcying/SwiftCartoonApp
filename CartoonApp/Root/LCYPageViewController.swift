//
//  LCYPageViewController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/2.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import HMSegmentedControl

enum LCYPageStyle {
    case noneStyle          //没有segment
    case navgationBarSegment//segment在导航栏上
    case topTabBar          //segment在页面最上方
}

class LCYPageViewController: LCYBaseViewController {
    // MARK: - property ------------------

    /*
     private(set)修饰将setter权限设置为private，在当前模块中只有此源文件可以访问，对外部是只读的
     */
    private(set) var titles: [String]!
    private(set) var vcs: [UIViewController]!
    private var pageStyle: LCYPageStyle!
    
    private var currentSelectedIndex: Int = 0
    
    
    // MARK: - life circle ----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    // MARK: - init ------------------

    /*
     在 init 前加上 convenience 关键字的初始化方法。
     这类方法只作为补充和提供使用上的方便。
     所有的 convenience 初始化方法都必须调用同一个类中的 designated 初始化完成设置，另外 convenience 的初始化方法是不能被子类重写或者是从子类中以 super 的方式被调用的。
     只要在子类中实现重写了父类 convenience 方法所需要的 init 方法的话，我们在子类中就可以使用父类的 convenience 初始化方法了。
     */
    
    convenience init(titles: [String] = [], vcs: [UIViewController] = [], pageStyle: LCYPageStyle = .noneStyle) {
        self.init()
        self.titles = titles
        self.pageStyle = pageStyle
        self.vcs = vcs
    }
    
    func initUI() {
        /*
         guard-else表示，如果guard成立则继续往下执行，不然在else中return
         */
        guard let vcs = vcs else { return }
        
        addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([vcs[0]], direction: .forward, animated: false, completion: nil)

        switch pageStyle {
        case .noneStyle?:
            pageViewController.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        case .navgationBarSegment?:
            segment.backgroundColor = .clear
            //设置标题颜色字体
            segment.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            //设置选中标题颜色字体
            segment.selectedTitleTextAttributes =  [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            segment.selectionIndicatorLocation = .none
            segment.frame = CGRect(x: 0, y: 0, width: screenWidth - 120, height: 40)
            
            //设置标题数组以及当前选中index
            segment.sectionTitles = titles
            currentSelectedIndex = 0
            segment.selectedSegmentIndex = currentSelectedIndex
            
            navigationItem.titleView = segment
            
            pageViewController.view.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        case .topTabBar?:
            
            segment.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            segment.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(r: 127, g: 221, b: 146, a: 1),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            segment.selectionIndicatorLocation = .down
            segment.selectionIndicatorColor = UIColor(r: 127, g: 221, b: 146, a: 1)
            segment.selectionIndicatorHeight = 2
            segment.borderType = .bottom
            segment.borderColor = UIColor.lightGray
            segment.borderWidth = 0.5
            
            view.addSubview(segment)
            segment.snp.makeConstraints{ (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(40)
            }
            
            //设置标题数组以及当前选中index
            segment.sectionTitles = titles
            currentSelectedIndex = 0
            segment.selectedSegmentIndex = currentSelectedIndex
            
            pageViewController.view.snp.makeConstraints{ (make) in
                make.top.equalTo(segment.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        default: break
        }
    }
    
    // MARK: - methods ------------------

    @objc func changeIndex(segment: UISegmentedControl) {
        let index = segment.selectedSegmentIndex
        if currentSelectedIndex != index {
            let viewController: UIViewController = vcs[index]
            let direction: UIPageViewController.NavigationDirection = currentSelectedIndex > index ? .reverse : .forward
            pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
            
            currentSelectedIndex = index
        }
    }
    
    // MARK: - lazy loading ------------------
    lazy var segment: HMSegmentedControl = {
        /*
         then是swift的一个初始化库
         */
        return HMSegmentedControl().then {
            $0.addTarget(self, action: #selector(changeIndex(segment:)), for: .valueChanged)
        }
    }()
    
    lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return pageVC
    }()

}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource ----
extension LCYPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController) else {
            return nil
        }
        let beforeIndex = index - 1
        guard beforeIndex >= 0 else {
            return nil
        }
        return vcs[beforeIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController) else {
            return nil
        }
        let afterIndex = index + 1
        guard afterIndex < vcs.count else {
            return nil
        }
        return vcs[afterIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.last, let index = vcs.firstIndex(of: viewController) else {
            return
        }
        currentSelectedIndex = index
        segment.setSelectedSegmentIndex(UInt(index), animated: true)
        navigationItem.title = titles[index]
    }
    
}
