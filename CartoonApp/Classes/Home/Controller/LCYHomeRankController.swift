//
//  LCYHomeRankController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/2.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYHomeRankController: LCYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(rankView)
        rankView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        rankView.tableView.mj_header = LCYRefreshHeader{[weak self] in
            self?.loadData()
        }
        rankView.tableView.mj_footer = LCYRefreshDiscoverFooter()
        
        rankView.tableView.emptyView = EmptyView.init(tapClosure: { [weak self] in
            self?.rankView.tableView.mj_header.beginRefreshing()
        })
        
        rankView.tableView.mj_header.beginRefreshing()
    }
    
    func loadData() {
        ApiLoadingProvider.request(.rankList, model: LCYRankinglistModel.self) { [weak self] (result) in
            self?.rankView.tableView.emptyView?.allowShow = true
            self?.rankView.rankModel = result
        }
    }
    
    // MARK: - lazy loading ------------
    lazy var rankView: LCYRankView = {
        let v = LCYRankView()
        return v
    }()

}
