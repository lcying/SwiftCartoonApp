//
//  LCYCategoryRankView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/11.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYCategoryRankView: UIView {
    //这个界面请求到的数据
    var defaultConTagType: String?
    
    var comicModelArray: Array<LCYComicModel>? {
        didSet {
            guard comicModelArray != nil else {
                return
            }
            self.tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lazy loading ---------
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.register(cellType: LCYCategoryRankCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()

}

extension LCYCategoryRankView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicModelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LCYCategoryRankCell.self)
        cell.defaultConTagType = defaultConTagType
        let model = comicModelArray![indexPath.row]
        cell.model = model
        cell.indexPath = indexPath
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = comicModelArray![indexPath.row]
        var comicId: Int = 0
        if model.comicId != 0 {
            comicId = model.comicId
        }
        
        if model.comic_id != 0 {
            comicId = model.comic_id
        }
        let vc = LCYComicController.init(comicId: comicId)
        
        self.parentController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
