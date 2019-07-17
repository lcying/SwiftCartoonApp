//
//  LCYSearchHeadView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/9.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYSearchHeadView: UICollectionReusableView, NibReusable {

    public var refreshBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func refreshAction(_ sender: UIButton) {
        refreshBlock!()
    }
    
}
