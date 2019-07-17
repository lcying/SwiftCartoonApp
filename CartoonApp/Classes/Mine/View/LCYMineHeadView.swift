//
//  LCYMineHeadView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/10.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYMineHeadView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "mine_bg_for_girl"))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()

}
