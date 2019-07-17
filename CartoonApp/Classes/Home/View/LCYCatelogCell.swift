//
//  LCYCatelogCell.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/12.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYCatelogCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.1).cgColor
        self.layer.borderWidth = 1.0
    }

}
