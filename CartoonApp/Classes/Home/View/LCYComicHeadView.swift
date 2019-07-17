//
//  LCYComicHeadView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/12.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYComicHeadView: UIView {

    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var clickLabel: UILabel!
    
    @IBOutlet weak var collectLabel: UILabel!
    
    @IBOutlet weak var tabView: UIView!
    
    var comicModel: LCYComicStaticModel? {
        didSet {
            guard let model = comicModel else {
                return
            }
            
            backImageView.kf.setImage(urlString: model.cover, placeholder: UIImage(named: "normal_placeholder_v"))
            imageView.kf.setImage(urlString: model.cover, placeholder: UIImage(named: "normal_placeholder_v"))
            titleLabel.text = model.name
            authorLabel.text = model.author?.name
            
            _ = tabView.subviews.map {
                $0.removeFromSuperview()
            }
            
            var labelBefore: UILabel?
            for (index, value) in (model.theme_ids?.enumerated())! {
                let label = UILabel.init()
                label.text = " \(value) "
                label.font = UIFont.systemFont(ofSize: 14)
                label.textColor = .white
                label.layer.cornerRadius = 3
                label.layer.masksToBounds = true
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.white.cgColor
                tabView.addSubview(label)
                if index == 0 {
                    label.snp.makeConstraints { (make) in
                        make.left.top.equalToSuperview().offset(0)
                    }
                } else {
                    label.snp.makeConstraints { (make) in
                        make.top.equalToSuperview().offset(0)
                        make.left.equalTo(labelBefore!.snp_right).offset(10)
                    }
                }
                labelBefore = label
            }
        }
    }
    
    var realtimeModel: LCYComicRealtimeModel? {
        didSet {
            guard let model = realtimeModel else {
                return
            }
            self.clickLabel.text = "\(String(describing: model.click_total!))"
            self.collectLabel.text = "\(String(describing: model.favorite_total!))"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
         在UIVisualEffectView.h中，定义了3个专门用来创建视觉特效的类
         它们分别是UIVisualEffect、UIBlurEffect和UIVibrancyEffect
         
         UIVisualEffect 继承自 NSObject.
         
         UIVisualEffect 有两个子类:UIBlurEffect和UIVibrancyEffect
         */
        //初始化一个模糊效果对象（可以制作毛玻璃效果）
        let blur = UIBlurEffect(style: .dark)
        //初始化一个基于模糊效果的视觉效果视图
        let blurView = UIVisualEffectView(effect: blur)

        backImageView.addSubview(blurView)
        blurView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
}
