//
//  LCYVipView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/5.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYVipView: UIView {
    let itemWidth = (screenWidth - 10.0) / 3.0
    let proportion = CGFloat(2.0)   //item的高：宽

    var vipListModel: LCYVipListModel? {
        didSet {
            guard vipListModel != nil else { return }
            self.collectionView.reloadData()
        }
    }
    
    var subscribeListModel: LCYSubscribeListModel? {
        didSet {
            guard subscribeListModel != nil else { return }
            self.collectionView.reloadData()
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
    
    // MARK: - lazy loading ---------
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * proportion)
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(cellType: LCYRecommandCell.self)
        cv.register(cellType: LCYRecommandImageCell.self)
        cv.register(supplementaryViewType: LCYRecommandHeadView.self, ofKind: UICollectionView.elementKindSectionHeader)
        cv.register(supplementaryViewType: LCYSeparatorFootView.self, ofKind: UICollectionView.elementKindSectionFooter)

        return cv
    }()
}

extension LCYVipView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if vipListModel != nil {
            return vipListModel?.newVipList?.count ?? 0
        } else {
            return subscribeListModel?.newSubscribeList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if vipListModel != nil {
            let vipList = vipListModel?.newVipList
            let comicList = vipList?[section]
            return comicList?.comics?.count ?? 0
        } else {
            let subscribeList = subscribeListModel?.newSubscribeList
            let comicList = subscribeList?[section]
            return comicList?.comics?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LCYRecommandCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if vipListModel != nil {
            let list = vipListModel?.newVipList?[indexPath.section]
            let currentModel = list?.comics?[indexPath.item]
            cell.comicModel = currentModel
        } else {
            let list = subscribeListModel?.newSubscribeList?[indexPath.section]
            let currentModel = list?.comics?[indexPath.item]
            cell.comicModel = currentModel
        }

        cell.detailLabel.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: LCYRecommandHeadView.self)
            
            let comicList: LCYComicListModel?
            
            if vipListModel != nil {
                comicList = self.vipListModel?.newVipList?[indexPath.section]
            } else {
                comicList = self.subscribeListModel?.newSubscribeList?[indexPath.section]
            }
            

            headView.iconImageView.kf.setImage(urlString: comicList?.titleIconUrl)
            headView.titleLabel.text = comicList?.itemTitle

            headView.moreButtonClosure { [weak self] in
                //点击跳转
                let vc = LCYCategoryRankController.init(argCon: comicList?.argCon ?? 0, argName: comicList?.argName ?? "", argValue: comicList?.argValue ?? 0)
                vc.title = comicList?.itemTitle
                self?.parentController()?.navigationController?.pushViewController(vc, animated: true)
            }
            
            return headView
        } else {
            
            let footView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: LCYSeparatorFootView.self)
            return footView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var model: LCYComicModel?
        if vipListModel != nil {
            let list = vipListModel?.newVipList?[indexPath.section]
            let currentModel = list?.comics?[indexPath.item]
            model = currentModel
        } else {
            let list = subscribeListModel?.newSubscribeList?[indexPath.section]
            let currentModel = list?.comics?[indexPath.item]
            model = currentModel
        }
        var comicId: Int = 0
        if model?.comicId != 0 {
            comicId = model?.comicId ?? 0
        }
        
        if model?.comic_id != 0 {
            comicId = model?.comic_id ?? 0
        }
        let vc = LCYComicController.init(comicId: comicId)
        self.parentController()?.navigationController?.pushViewController(vc, animated: true)
        
    }
}

