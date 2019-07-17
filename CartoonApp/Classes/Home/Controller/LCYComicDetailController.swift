//
//  LCYComicDetailController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/11.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYComicDetailController: LCYBaseViewController {

    weak var delegate: LCYComicWillEndDragingDelegate?
    
    var realtimeModel: LCYComicRealtimeModel?
    var detailStatic: LCYDetailStaticModel?
    var guessLike: LCYGuessLikeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - lazy loading --------
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let width = (screenWidth - 50) / 4.0 - 1
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(cellType: LCYCategoryCell.self)
        cv.register(supplementaryViewType: LCYDetailHeadView.self, ofKind: UICollectionView.elementKindSectionHeader)
        cv.backgroundColor = .white
        return cv
    }()
    
    
}

extension LCYComicDetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guessLike?.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LCYCategoryCell.self)
        
        let model: LCYComicModel = (guessLike?.comics![indexPath.item])!
        
        cell.imageView.kf.setImage(urlString: model.cover)
        cell.titleLabel.text = model.name ?? model.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: LCYDetailHeadView.self)
            
            view.otherWorks = detailStatic?.otherWorks
            
            //简介
            view.descLabel.text = "【\(detailStatic?.comic?.cate_id ?? "")】\(detailStatic?.comic?.description ?? "")"
            
            //其他作品数量
            if detailStatic?.otherWorks!.count ?? 0 == 0 {
                view.otherViewHeight.constant = 0
                view.otherView.isHidden = true
            } else {
                view.otherViewHeight.constant = 50
                view.otherView.isHidden = false
            }
            view.otherCountLabel.text = "\(detailStatic?.otherWorks?.count ?? 0)本"
            
            //本月月票
            view.currentMonthLabel.text = realtimeModel?.monthly_ticket
            
            //累计月票
            view.totalLabel.text = realtimeModel?.total_ticket
            
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var height: CGFloat = 136
        
        if detailStatic?.otherWorks!.count ?? 0 > 0 {
            height += 50
        }
        
        let string = "【\(detailStatic?.comic?.cate_id ?? "")】\(detailStatic?.comic?.description ?? "")"
        
        let rect = NSString.init(string: string).boundingRect(with: CGSize(width: screenWidth - 24, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        
        height += rect.height
        
        return CGSize(width: screenWidth, height: height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.delegate?.comicWillEndDragging(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: LCYComicModel = (guessLike?.comics![indexPath.item])!
        let vc = LCYComicController(comicId: model.comic_id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
