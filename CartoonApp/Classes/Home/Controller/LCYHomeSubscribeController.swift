//
//  LCYHomeSubscribeController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/2.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYHomeSubscribeController: LCYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(vipView)
        vipView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        vipView.collectionView.mj_header = LCYRefreshHeader { [weak self] in
            self?.loadData()
        }
        
        vipView.collectionView.mj_footer = LCYVIPRefreshFooter.init(tip: "VIP用户专享\nVIP用户可以免费阅读全部漫画哦~")
        vipView.collectionView.emptyView = EmptyView.init(tapClosure: { [weak self] in
            //点击无数据页面重新加载数据
            self?.loadData()
        })
        
        vipView.collectionView.mj_header.beginRefreshing()
    }
    
    func loadData() {
        ApiLoadingProvider.request(LCYApi.subscribeList, model: LCYSubscribeListModel.self) { [weak self] (resultData) in
            self?.vipView.collectionView.emptyView?.allowShow = true
            self?.vipView.subscribeListModel = resultData
            self?.vipView.collectionView.mj_header.endRefreshing()
        }
    }
    
    // MARK: - lazy loading -------------
    lazy var vipView: LCYVipView = {
        let v = LCYVipView(frame: CGRect.zero)
        return v
    }()

}
