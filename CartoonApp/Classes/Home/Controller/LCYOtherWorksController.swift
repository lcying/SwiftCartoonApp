//
//  LCYOtherWorksController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/16.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYOtherWorksController: LCYBaseViewController {

    //上个界面已经请求到数据，直接传过来就行
    var otherWorks: [LCYOtherWorkModel]?
    
    convenience init(otherWorks: [LCYOtherWorkModel]) {
        self.init()
        self.otherWorks = otherWorks
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController!.barStyle(.theme)    //设置导航栏背景色
        navigationController?.navigationBar.isTranslucent = false
        self.title = "其他作品"
    }
    
    // MARK: - lazy loading --------
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let width = (screenWidth - 40) / 3.0 - 1
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(cellType: LCYCategoryCell.self)
        cv.backgroundColor = .white
        return cv
    }()
    
    
}

extension LCYOtherWorksController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherWorks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LCYCategoryCell.self)
        
        let model: LCYOtherWorkModel = (otherWorks![indexPath.item])
        
        cell.imageView.kf.setImage(urlString: model.coverUrl)
        cell.titleLabel.text = model.name
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: LCYOtherWorkModel = (otherWorks![indexPath.item])
        let vc = LCYComicController(comicId: model.comicId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
