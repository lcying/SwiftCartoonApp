//
//  LCYMineViewController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/1.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYMineViewController: LCYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top

        self.view.addSubview(mineView)
        mineView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func configNavigationBar() {
        super.configNavigationBar()
        self.title = nil
        navigationController?.barStyle(.clear)
        self.navigationController?.title = nil
        navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - lazy loading ----
    lazy var mineView: LCYMineView = {
        let view = LCYMineView(frame: CGRect.zero)
        return view
    }()
}
