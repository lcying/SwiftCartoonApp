//
//  LCYCategoryRankController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/10.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import MJRefresh

class LCYCategoryRankController: LCYBaseViewController {

    //上个界面传过来的数据
    var argCon: Int = 0
    var argName: String?
    var argValue: Int = 0
    
    var page: Int = 0
    
    /*
     convenience:便利，使用convenience修饰的构造函数叫做便利构造函数
     便利构造函数通常用在对系统的类进行构造函数的扩充时使用。
     便利构造函数的特点：
     1、便利构造函数通常都是写在extension里面，也可以用在类里面
     2、便利函数init前面需要加载convenience
     3、在便利构造函数中需要明确的调用self.init()
     */
    
    convenience init(argCon: Int, argName: String, argValue: Int) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(rankView)
        rankView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        rankView.tableView.mj_header = LCYRefreshHeader { [weak self] in
            self?.loadData(more: false)
        }
        
        rankView.tableView.mj_footer = MJRefreshBackNormalFooter { [weak self] in
            self?.loadData(more: true)
        }
        
        rankView.tableView.emptyView = EmptyView.init(tapClosure: { [weak self] in
            self?.loadData(more: false)
        })
        
        rankView.tableView.mj_header.beginRefreshing()
    }
    
    func loadData(more: Bool) {
        page = (more ? page+1 : 1)
        ApiProvider.request(.comicList(argCon: argCon, argName: argName ?? "", argValue: argValue, page: page), model: LCYComicListModel.self) { [weak self] (result) in
            //comics
            self?.rankView.tableView.mj_header.endRefreshing()
            if result?.comics?.count == 0 {
                self?.rankView.tableView.mj_footer.endRefreshingWithNoMoreData()
            } else {
                self?.rankView.tableView.mj_footer.endRefreshing()
            }
            
            self?.rankView.defaultConTagType = result?.defaultParameters?.defaultConTagType

            let array = result?.comics
            if more {
                guard let array = array else { return }
                self?.rankView.comicModelArray?.append(contentsOf: array)
            } else {
                self?.rankView.comicModelArray = array
            }
        }
    }
    

    // MARK: - lazy loading ----------------
    lazy var rankView: LCYCategoryRankView = {
        let view = LCYCategoryRankView(frame: CGRect.zero)
        
        return view
    }()

}
