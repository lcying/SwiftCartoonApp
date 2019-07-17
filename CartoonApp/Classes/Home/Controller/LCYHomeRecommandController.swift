//
//  LCYHomeRecommandController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/2.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import MJRefresh

class LCYHomeRecommandController: LCYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(recommandView)
        recommandView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        //添加刷新
        recommandView.collectionView.mj_header = LCYRefreshHeader { [weak self] in
            self?.loadData()
        }
        
        recommandView.collectionView.mj_footer = LCYRefreshDiscoverFooter()
        
        recommandView.collectionView.mj_header.beginRefreshing()
        
        recommandView.collectionView.emptyView = EmptyView.init(verticalOffset:-recommandView.collectionView.contentInset.top ,tapClosure: { [weak self] in
            //点击无数据页面重新加载数据
            self?.loadData()
        })
    }
    
    // MARK: - methods ----------------
    
    func loadData() {
        ApiProvider.request(.boutiqueList(sexType: 1), model: LCYBoutiqueListModel.self) { [weak self] (returnData) in
            self?.recommandView.collectionView.emptyView?.allowShow = true

            self?.recommandView.model = returnData
            self?.recommandView.collectionView.mj_header.endRefreshing()
            self?.recommandView.changeSexButton.setImage(UIImage.init(named: self?.recommandView.sexType == 1 ? "gender_male" : "gender_female"), for: .normal)

        }
    }
    
    // MARK: - lazy loading ------------------
    lazy var recommandView: LCYHomeRecommandView = {
        let view = LCYHomeRecommandView.init(frame: CGRect.zero)
        return view
    }()
    
}
