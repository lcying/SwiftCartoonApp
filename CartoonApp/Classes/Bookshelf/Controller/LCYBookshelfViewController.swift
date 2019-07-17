//
//  LCYBookshelfViewController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/1.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYBookshelfViewController: LCYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(categoryView)
        categoryView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        requestData()
    }
    
    func requestData() {
        ApiLoadingProvider.request(.cateList, model: LCYCateListModel.self) { [weak self] (result) in
            self?.categoryView.model = result
        }
    }
    
    // MARK: - lazy loading -------------

    lazy var categoryView: LCYCategoryView = {
        let view = LCYCategoryView()
        
        return view
    }()

}
