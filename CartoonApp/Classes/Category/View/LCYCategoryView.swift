//
//  LCYCategoryView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/9.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYCategoryView: UIView {

    var model: LCYCateListModel? {
        didSet {
            guard model != nil else {
                return
            }
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lazy loading --------
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth - 41) / 3.0, height: (screenWidth - 41) / 3.0)
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(cellType: LCYCategoryCell.self)
        cv.backgroundColor = .white
        return cv
    }()
    

}

extension LCYCategoryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.rankingList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LCYCategoryCell.self)
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.masksToBounds = true
        let currentModel: LCYRankingModel = (self.model?.rankingList![indexPath.item])!
        cell.imageView.kf.setImage(urlString: currentModel.cover)
        cell.titleLabel.text = currentModel.sortName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentModel: LCYRankingModel = (self.model?.rankingList![indexPath.item])!
        let vc =  LCYCategoryRankController.init(argCon: currentModel.argCon, argName: currentModel.argName ?? "", argValue: currentModel.argValue)
        vc.title = currentModel.sortName
        self.parentController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
