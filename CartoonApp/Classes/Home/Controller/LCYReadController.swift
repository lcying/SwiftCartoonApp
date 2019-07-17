//
//  LCYReadController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/16.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import MJRefresh

class LCYReadController: LCYBaseViewController {

    //上个界面传过来的数据
    var detailStatic: LCYDetailStaticModel?
    
    //上个界面传过来的选中章节
    var selectedIndex: Int = 0
    
    //章节内容数组
    var chapterModelArray = [LCYChapterModel]() //初始化了
    
    convenience init(detailStatic: LCYDetailStaticModel?, selectedIndex: Int) {
        self.init()
        self.detailStatic = detailStatic
        self.selectedIndex = selectedIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(backScrollView)
        backScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backScrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalTo(backScrollView)
        }
        
//        navigationController?.setNavigationBarHidden(true, animated: true)
        
        collectionView.mj_header = MJRefreshHeader { [weak self] in
            self?.loadData(index: (self?.selectedIndex ?? 0) - 1)
        }
        
        collectionView.mj_footer = MJRefreshAutoFooter { [weak self] in
            self?.loadData(index: (self?.selectedIndex ?? 0) + 1)
        }
        
        loadData(index: selectedIndex)
    }

    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.white)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_black"), target: self, action: #selector(pressBack))
        self.title = detailStatic?.comic?.name
    }
    
    @objc func pressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapAction() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func doubleTapAction() {
        var zoomScale = backScrollView.zoomScale
        zoomScale = 2.5 - zoomScale
        let width = view.frame.width / zoomScale
        let height = view.frame.height / zoomScale
        let zoomRect = CGRect(x: backScrollView.center.x - width / 2 , y: backScrollView.center.y - height / 2, width: width, height: height)
        backScrollView.zoom(to: zoomRect, animated: true)
    }
    
    func loadData(index: Int) {
        if index <= -1 {
            self.collectionView.mj_header.endRefreshing()
            UNoticeBar.init(config: UNoticeBarConfig.init(title: "已经是第一章了", image: UIImage.init(named: "yaofan"), textColor: .black, backgroundColor: .lightGray, barStyle: UNoticeBarStyle.onNavigationBar, animationType: UNoticeBarAnimationType.top)).show(duration: 2.0)
            return
        }
        
        if index >= detailStatic?.chapter_list?.count ?? 0 {
            self.collectionView.mj_footer.endRefreshing()
            UNoticeBar.init(config: UNoticeBarConfig.init(title: "已经没有了", image: UIImage.init(named: "yaofan"), textColor: .black, backgroundColor: .lightGray, barStyle: UNoticeBarStyle.onNavigationBar, animationType: UNoticeBarAnimationType.top)).show(duration: 2.0)
            return
        }
        
        let chapterId = detailStatic?.chapter_list?[index].chapter_id ?? 0
        ApiLoadingProvider.request(.chapter(chapter_id: chapterId), model: LCYChapterModel.self) { [weak self] (result) in
            
            self?.collectionView.mj_header.endRefreshing()
            self?.collectionView.mj_footer.endRefreshing()
            
            guard let chapterData = result else { return }
            
            if index < self?.selectedIndex ?? 0 {
                self?.chapterModelArray.insert(chapterData, at: 0)
            }
            if index >= self?.selectedIndex ?? 0 {
                self?.chapterModelArray.append(chapterData)
            }
            
            self?.collectionView.reloadData()
            
            self?.selectedIndex = index

        }
    }
 
    // MARK: - lazy loading --------
    
    lazy var backScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.5
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)//如果tap失败会用doubleTap替代
        
        return scrollView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = LCYSearchFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.register(cellType: LCYReadCell.self)
        return cv
    }()
    
}

extension LCYReadController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chapterModelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapterModelArray[section].image_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LCYReadCell.self)
        
        let model = chapterModelArray[indexPath.section].image_list?[indexPath.item]
        
        cell.imageView.kf.setImage(urlString: model?.location)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let image = chapterModelArray[indexPath.section].image_list?[indexPath.row] else {
            return CGSize.zero
        }
        let height = floor(screenWidth / CGFloat(image.width) * CGFloat(image.height))
        
        return CGSize(width: screenWidth, height: height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /*
     *** Terminating app due to uncaught exception 'NSGenericException', reason: 'The view returned from viewForZoomingInScrollView: must be a subview of the scroll view. It can not be the scroll view itself.'
     */
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == backScrollView {
            return collectionView
        } else {
            return nil
        }
    }
}

