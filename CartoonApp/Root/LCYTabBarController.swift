//
//  LCYTabBarController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/1.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        
        let homeVC = LCYHomeViewController(titles: ["推荐",
                                                    "VIP",
                                                    "订阅",
                                                    "排行"],
                                           vcs: [LCYHomeRecommandController(),
                                                 LCYHomeVipController(),
                                                 LCYHomeSubscribeController(),
                                                 LCYHomeRankController()],
                                           pageStyle: .navgationBarSegment)
        
        let categoryVC = LCYCategoryViewController()
        let bookshelfVC = LCYBookshelfViewController()
        let mineVC = LCYMineViewController()
        
        addChildViewController(childVC: homeVC, title: "首页", imageName: "tab_home", selectedImageName: "tab_home_S")
        addChildViewController(childVC: categoryVC, title: "分类", imageName: "tab_class", selectedImageName: "tab_class_S")
        addChildViewController(childVC: bookshelfVC, title: "书架", imageName: "tab_book", selectedImageName: "tab_book_S")
        addChildViewController(childVC: mineVC, title: "我的", imageName: "tab_mine", selectedImageName: "tab_mine_S")
    }

    func addChildViewController(childVC: UIViewController, title: String, imageName: String, selectedImageName: String) {
        childVC.title = title
        childVC.tabBarItem = UITabBarItem.init(title: nil, image: UIImage.init(named: imageName), selectedImage: UIImage.init(named: selectedImageName))
        childVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        addChild(LCYNavigationController(rootViewController: childVC))
    }

}

extension LCYTabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else {
            return .lightContent
        }
        return select.preferredStatusBarStyle
    }
}
