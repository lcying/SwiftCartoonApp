//
//  LCYRankView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/5.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYRankView: UIView {

    var rankModel: LCYRankinglistModel? {
        didSet {
            guard rankModel != nil else {
                return
            }
            tableView.reloadData()
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
    
    
    // MARK: - lazy loading ----------
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: LCYRankCell.self)
        tableView.tableFooterView = UIView()
        return tableView
    }()
}

extension LCYRankView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return rankModel?.rankinglist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LCYRankCell.self)
        cell.rankModel = rankModel?.rankinglist?[indexPath.section]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = rankModel?.rankinglist?[indexPath.section]
        let vc = LCYCategoryRankController.init(argCon: model?.argCon ?? 0, argName: model?.argName ?? "", argValue: model?.argValue ?? 0)
        vc.title = "\(model?.title ?? "")榜"
        self.parentController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
