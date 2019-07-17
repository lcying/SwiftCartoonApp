//
//  LCYComicCommentController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/11.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import MJRefresh

class LCYComicCommentController: LCYBaseViewController {

    weak var delegate: LCYComicWillEndDragingDelegate?

    var object_id: Int = 0
    var thread_id: Int = 0
    
    var serverNextPage: Int = 0
    var commentModelArray: [LCYCommentModel]? {
        didSet {
            guard commentModelArray != nil else {
                return
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.mj_header = LCYRefreshHeader { [weak self] in
            self?.loadData(isMore: false)
        }
        
        tableView.mj_footer = MJRefreshBackNormalFooter { [weak self] in
            self?.loadData(isMore: true)
        }
        
        tableView.emptyView = EmptyView { [weak self] in
            self?.loadData(isMore: false)
        }
        
        tableView.mj_header.beginRefreshing()
    }
    
    func loadData(isMore: Bool) {
        ApiProvider.request(.commentList(object_id: object_id, thread_id: thread_id, page: serverNextPage), model: LCYCommentListModel.self) { [weak self] (result) in
            
            self?.tableView.mj_header.endRefreshing()
            if result!.hasMore {
                self?.tableView.mj_footer.endRefreshing()
            } else {
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
            let array = result!.commentList
            if isMore {
                guard let array = array else { return }
                self?.commentModelArray?.append(contentsOf: array)
            } else {
                self?.commentModelArray = array
            }
            self?.serverNextPage = result?.serverNextPage ?? 0
        }
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.register(cellType: LCYCommentCell.self)
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
}


extension LCYComicCommentController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentModelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LCYCommentCell.self)
        let model = self.commentModelArray![indexPath.row]
        
        cell.commentLabel.text = model.content_filter
        cell.nameLabel.text = model.nickname
        cell.headImageView.kf.setImage(urlString: model.face)
        
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
}
