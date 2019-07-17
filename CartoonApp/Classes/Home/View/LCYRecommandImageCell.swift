//
//  LCYRecommandImageCell.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/4.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYRecommandImageCell: UICollectionViewCell, NibReusable {

    var comicModel: LCYComicModel? {
        didSet {
            guard let model = comicModel else { return }
            imageView.kf.setImage(urlString: model.cover,
                                  placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
