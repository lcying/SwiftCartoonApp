//
//  LCYBaseViewController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/1.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.background
        
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    
    func configNavigationBar() {
        guard let navi = self.navigationController else {
            return
        }
        if navi.visibleViewController == self {
            navi.navigationBar.isTranslucent = false
            navi.barStyle(.theme)    //设置导航栏背景色
            navi.setNavigationBarHidden(false, animated: false)
            if navi.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "nav_back_white"), style: .plain, target: self, action: #selector(backAction))   //设置导航栏返回按钮
            }
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
