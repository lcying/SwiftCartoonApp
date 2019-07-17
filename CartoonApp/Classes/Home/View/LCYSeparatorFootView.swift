//
//  LCYSeparatorFootView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/5.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYSeparatorFootView: UICollectionReusableView, Reusable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.background
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
