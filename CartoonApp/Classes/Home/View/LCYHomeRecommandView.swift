//
//  LCYHomeRecommandView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/2.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import LLCycleScrollView

class LCYHomeRecommandView: UIView {

    let itemWidth = (screenWidth - 5.0) / 2.0
    let proportion = CGFloat(0.75)   //item的高：宽
    
    /*
     0 女
     1 男
     */
    var sexType: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    
    var model: LCYBoutiqueListModel? {
        didSet {
            guard let model = model else { return }
            /*
             filter筛选出符合条件的model，map再返回model中的cover作为array
             */
            self.bannerView.imagePaths = model.galleryItems?.filter({ (model) -> Bool in
                model.cover != nil
            }).map({ (model) in
                model.cover!
            }) ?? []

            self.collectionView.reloadData()
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(collectionView.contentInset.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods -------------------

    //轮播图点击
    func didSelectAtIndex(index: NSInteger) {
        
    }
    
    @objc func changeSexAction() {
        self.sexType = 1 - self.sexType
        UserDefaults.standard.set(self.sexType, forKey: String.sexTypeKey)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .USexTypeDidChange, object: nil)
    }
    
    // MARK: - lazy loading -------------------
    
    lazy var bannerView: LLCycleScrollView = {
        let view = LLCycleScrollView.init()
        view.autoScrollTimeInterval = 6
        view.placeHolderImage = UIImage.init(named: "normal_placeholder")
        view.coverImage = UIImage(named: "normal_placeholder_h")
        view.pageControlPosition = .center
        view.lldidSelectItemAtIndex = didSelectAtIndex(index:)
        view.pageControlBottom = 30
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * proportion)
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        cv.contentInset = UIEdgeInsets(top: screenWidth * 0.467, left: 0, bottom: 0, right: 0)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(cellType: LCYRecommandCell.self)
        cv.register(cellType: LCYRecommandImageCell.self)
        cv.register(supplementaryViewType: LCYRecommandHeadView.self, ofKind: UICollectionView.elementKindSectionHeader)
        
        cv.register(supplementaryViewType: LCYSeparatorFootView.self, ofKind: UICollectionView.elementKindSectionFooter)

        return cv
    }()
    
    lazy var changeSexButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(changeSexAction), for: .touchUpInside)
        return button
    }()
}

extension LCYHomeRecommandView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.model?.comicLists?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = self.model?.comicLists?[section]
        //取前四个
        return comicList?.comics?.prefix(4).count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicList = self.model?.comicLists?[indexPath.section]
        let comicModel = comicList?.comics?[indexPath.item]
        if comicList?.comicType == LCYComicType.billboard {
            //只有图片cell
            let cell: LCYRecommandImageCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.comicModel = comicModel
            return cell
        } else {
            let cell: LCYRecommandCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.comicModel = comicModel
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: LCYRecommandHeadView.self)
            
            let comicList = self.model?.comicLists?[indexPath.section]
            
            headView.iconImageView.kf.setImage(urlString: comicList?.newTitleIconUrl)
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
        let comicList = self.model?.comicLists?[indexPath.section]
        let comicModel = comicList?.comics?[indexPath.item]
        
        if comicList?.comicType == .billboard {
            //榜单
            
        } else {
            if comicModel?.linkType == 2 {
                //webview
                guard let url = comicModel?.ext?.compactMap({
                    return $0.key == "url" ? $0.val : nil
                }).joined() else {
                    return
                }

                let vc = LCYWebViewController()
                vc.urlString = url
                self.parentController()?.navigationController?.pushViewController(vc, animated: true)

            } else {
                let vc = LCYComicController(comicId: comicModel?.comicId ?? 0)
                self.parentController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //轮播图和collection联动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            bannerView.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top)))
            }
        }
    }
    
}
