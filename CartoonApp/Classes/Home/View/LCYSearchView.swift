//
//  LCYSearchView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/8.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

typealias IndexPathBlock = ((Int) -> Void)

class LCYSearchView: UIView {
    
    var searchClickBlock: IndexPathBlock?
    var refreshBlock: (() -> Void)?
    
    var searchHistoryModel: LCYHotItemsModel? {
        didSet {
            guard searchHistoryModel != nil else {
                return
            }
            self.collectionView.reloadData()
        }
    }
    
    var searchResultModelArray: [LCYSearchItemModel]? {
        didSet {
            guard searchResultModelArray != nil else {
                return
            }
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }

    public func searchCallBack(_ block: @escaping IndexPathBlock) {
        searchClickBlock = block
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingCollectionViewItemWidthBounding(with text: String) -> CGSize {
        let sizeWidth = CGSize(width: CGFloat(MAXFLOAT), height: 20)
        let sizeHeight = CGSize(width: screenWidth - 40, height: CGFloat(MAXFLOAT))
        
        let attributeDic = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let frameWidth = text.boundingRect(with: sizeWidth, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributeDic, context: nil)
        
        let frameHeight = text.boundingRect(with: sizeHeight, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributeDic, context: nil)
        
        var finalSize = CGSize(width: frameWidth.size.width + 21, height: 30)
        
        if frameWidth.size.width > screenWidth - 40 {
            finalSize = CGSize(width: screenWidth - 40, height: frameHeight.size.height + 10)
        }
        
        return finalSize
        
    }
    
    // MARK: - lazy loading --------
    
    lazy var collectionView: UICollectionView = {
        let layout = LCYSearchFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(cellType: LCYSearchCVCell.self)
        cv.register(supplementaryViewType: LCYSearchHeadView.self, ofKind: UICollectionView.elementKindSectionHeader)
        cv.backgroundColor = .white
        return cv
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        return tableView
    }()
}

extension LCYSearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchHistoryModel?.hotItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LCYSearchCVCell.self)
        let itemModel = searchHistoryModel?.hotItems![indexPath.item]
        cell.titleLabel.text = itemModel?.name
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemModel = searchHistoryModel?.hotItems![indexPath.item]
        return self.settingCollectionViewItemWidthBounding(with: (itemModel?.name)!)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: LCYSearchHeadView.self)
            view.refreshBlock = { [weak self] in
                self?.refreshBlock!()
            }
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchBlock = searchClickBlock else {
            return
        }
        let itemModel = searchHistoryModel?.hotItems![indexPath.item]
        searchBlock(itemModel?.comic_id ?? 0)
    }
}


extension LCYSearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResultModelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = self.searchResultModelArray![indexPath.row] as LCYSearchItemModel
        
        cell.textLabel!.text = model.name
        
        return cell
    }
    
    
}
