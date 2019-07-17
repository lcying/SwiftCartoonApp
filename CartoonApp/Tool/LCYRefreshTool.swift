//
//  LCYRefreshTool.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/4.
//  Copyright © 2019 lcy. All rights reserved.
//

import MJRefresh

class LCYRefreshHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()
        setImages([UIImage(named: "refresh_normal")!], for: .idle)
        setImages([UIImage(named: "refresh_will_refresh")!], for: .pulling)
        setImages([UIImage(named: "refresh_loading_1")!,
                   UIImage(named: "refresh_loading_2")!,
                   UIImage(named: "refresh_loading_3")!], for: .refreshing)
        lastUpdatedTimeLabel.isHidden = true
        stateLabel.isHidden = true
    }
}

class LCYRefreshDiscoverFooter: MJRefreshBackGifFooter {
    override func prepare() {
        super.prepare()
        backgroundColor = UIColor.background
        setImages([UIImage(named: "refresh_discover")!], for: .idle)
        stateLabel.isHidden = true
        refreshingBlock = {
            self.endRefreshing()
        }
    }
}

/*
 MJRefreshBackFooter：MJRefresh提供的可供自定义的footer
 */
class LCYVIPRefreshFooter: MJRefreshBackFooter {
    override func prepare() {
        super.prepare()
        addSubview(tipLabel)
        addSubview(imageView)
        //设置refreshFooterView的高度
        mj_h = 240
    }
    
    //在这个方法里面设置frame，不然frame会不准
    override func placeSubviews() {
        self.tipLabel.frame = CGRect(x: 0, y: 40, width: bounds.width, height: 60)
        self.imageView.frame = CGRect(x: (bounds.width - 80 ) / 2, y: 110, width: 80, height: 80)
    }
    
    convenience init(tip: String) {
        self.init()
        self.tipLabel.text = tip
        refreshingBlock = {
            self.endRefreshing()
        }
    }
    
    lazy var tipLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageV = UIImageView.init(image: UIImage.init(named: "refresh_kiss"))
        return imageV
    }()
}
