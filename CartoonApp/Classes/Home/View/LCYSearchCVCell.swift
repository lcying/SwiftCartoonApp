//
//  LCYSearchCVCellCollectionViewCell.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/9.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYSearchCVCell: UICollectionViewCell, Reusable {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(r: 240, g: 240, b: 240, a: 1)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
}
