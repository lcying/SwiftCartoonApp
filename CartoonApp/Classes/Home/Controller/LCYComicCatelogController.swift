//
//  LCYComicCatelogController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/11.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYComicCatelogController: LCYBaseViewController {

    var reversed: Bool = false //是否倒序
    
    var last_update_time: TimeInterval = 0 //最新更新时间
    
    var detailStatic: LCYDetailStaticModel? //点击阅读用到的
    
    weak var delegate: LCYComicWillEndDragingDelegate?

    var chapter_list: [LCYChapterStaticModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        // Do any additional setup after loading the view.
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func changeReverseState() {
        self.reversed = !self.reversed
        self.collectionView.reloadData()
    }
    
    // MARK: - lazy loading --------
    
    lazy var collectionView: UICollectionView = {
        let layout = LCYSearchFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth - 30) / 2.0 - 1, height: 35)
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(cellType: LCYCatelogCell.self)
        cv.register(supplementaryViewType: LCYCatelogHeadView.self, ofKind: UICollectionView.elementKindSectionHeader)
        cv.backgroundColor = .white
        return cv
    }()
    

}

extension LCYComicCatelogController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapter_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LCYCatelogCell.self)
        var model:LCYChapterStaticModel?
        if reversed {
            model = self.chapter_list?.reversed()[indexPath.item]
        } else {
            model = self.chapter_list![indexPath.item]
        }
        cell.label.text = model?.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: LCYCatelogHeadView.self)
            view.orderButton.addTarget(self, action: #selector(changeReverseState), for: .touchUpInside)
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd hh:mm:ss"
            view.titleLabel.text = "目录 \(format.string(from: Date(timeIntervalSince1970: self.last_update_time))) 更新 \(self.chapter_list?.last?.name ?? "")"
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 40)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.delegate?.comicWillEndDragging(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = reversed ? (self.detailStatic?.chapter_list!.count ?? 0 - indexPath.item - 1) : indexPath.item
        let vc = LCYReadController.init(detailStatic: detailStatic, selectedIndex: index)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
