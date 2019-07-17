//
//  LCYComicController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/11.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

//继承自class才能用weak修饰
protocol LCYComicWillEndDragingDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}

class LCYComicController: LCYBaseViewController {

    var comicId: Int = 0
    
    convenience init(comicId: Int) {
        self.init()
        self.comicId = comicId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalTo(screenWidth)
            make.height.equalTo(screenHeight)
        }
        contentScrollView.addSubview(headView)
        headView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 150 + navigationBarY)

        contentScrollView.addSubview(pageContentView)
        pageContentView.frame = CGRect(x: 0, y: 150 + navigationBarY, width: screenWidth, height: screenHeight - navigationBarY)
       
        self.addChild(pageVC)
        pageContentView.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loadData()
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController!.barStyle(.clear)    //设置导航栏背景色
        self.navigationController?.title = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func loadData() {
        let group = DispatchGroup()
        
        group.enter()
        ApiLoadingProvider.request(.detailStatic(comicid: comicId), model: LCYDetailStaticModel.self) { [weak self] (result) in
            group.leave()

            //评论
            self?.comicCommentVC.thread_id = result?.comic?.thread_id ?? 0
            self?.comicCommentVC.object_id = result?.comic?.comic_id ?? 0
            
            //目录
            self?.comicCatelogVC.chapter_list = result?.chapter_list
            self?.comicCatelogVC.collectionView.reloadData()
            self?.comicCatelogVC.last_update_time = (result?.comic!.last_update_time)!
            self?.comicCatelogVC.detailStatic = result
            
            //头部视图
            self?.headView.comicModel = result?.comic
            
            //详情
            self?.comicDetailVC.detailStatic = result
        }
        
        group.enter()
        ApiProvider.request(.detailRealtime(comicid: comicId), model: LCYDetailRealtimeModel.self) { [weak self] (result) in
            group.leave()

            //头部视图
            self?.headView.realtimeModel = result?.comic
            
            //详情
            self?.comicDetailVC.realtimeModel = result?.comic
        }
        
        group.enter()
        ApiProvider.request(.guessLike, model: LCYGuessLikeModel.self) { [weak self] (result) in
            group.leave()
            self?.comicDetailVC.guessLike = result
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.comicDetailVC.collectionView.reloadData()
        }
    }
    
    // MARK: - lazy loading ---------------
    //导航栏高度
    private lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    lazy var contentScrollView: UIScrollView = {
        let sc = UIScrollView.init()
        sc.contentSize = CGSize(width: screenWidth, height: screenHeight + 150)
        sc.delegate = self
        return sc
    }()
    
    lazy var headView: LCYComicHeadView = {
        let v = Bundle.main.loadNibNamed("LCYComicHeadView", owner: self, options: nil)?.last as! LCYComicHeadView
        return v
    }()
    
    lazy var pageContentView: UIView = {
        let v = UIView()
        v.backgroundColor = .yellow
        return v
    }()
    
    lazy var pageVC: LCYPageViewController = {
        let vc = LCYPageViewController.init(titles: ["详情", "目录", "评论"], vcs: [comicDetailVC, comicCatelogVC, comicCommentVC], pageStyle: LCYPageStyle.topTabBar)
        vc.view.backgroundColor = .green
        return vc
    }()
    
    lazy var comicDetailVC: LCYComicDetailController = {
        let vc = LCYComicDetailController()
        vc.delegate = self
        return vc
    }()

    lazy var comicCatelogVC: LCYComicCatelogController = {
        let vc = LCYComicCatelogController()
        vc.delegate = self
        return vc
    }()
    
    lazy var comicCommentVC: LCYComicCommentController = {
        let vc = LCYComicCommentController()
        vc.delegate = self
        return vc
    }()
}

extension LCYComicController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 150 {
            navigationController?.barStyle(.theme)
            navigationItem.title = "haha"
        } else {
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
        
        if scrollView.contentOffset.y < 0 {
            self.headView.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: screenWidth, height: -scrollView.contentOffset.y + 150 + navigationBarY)
        }
        
    }
}

extension LCYComicController: LCYComicWillEndDragingDelegate {
    func comicWillEndDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            self.contentScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else {
            self.contentScrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
    }
}
