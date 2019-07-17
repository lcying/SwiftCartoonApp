//
//  LCYCategoryCell.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/9.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYCategoryCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
