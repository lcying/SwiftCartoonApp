//
//  LCYCategoryViewController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/1.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYCategoryViewController: LCYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(categoryView)
        categoryView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        requestData()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.titleView = searchButton
    }
    
    @objc func searchAction() {
        self.navigationController?.pushViewController(LCYSearchViewController(), animated: true)
    }
    
    func requestData() {
        ApiLoadingProvider.request(.cateList, model: LCYCateListModel.self) { [weak self] (result) in
            self?.categoryView.model = result
        }
    }
    
    // MARK: - lazy loading -------------
    
    lazy var searchButton: UIButton = {
        let button = UIButton.init()
        button.frame = CGRect(x: 0, y: 0, width: screenWidth - 30, height: 30)
        button.backgroundColor = UIColor.init(r: 255, g: 255, b: 255, a: 0.3)
        button.setImage(UIImage.init(named: "nav_search"), for: .normal)
        button.setTitle("   搜索", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return button
    }()

    lazy var categoryView: LCYCategoryView = {
        let view = LCYCategoryView()
        
        return view
    }()
}
