//
//  LCYRecommandHeadView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/2.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

/*
 typealias用来为已存在的类型重新定义名称的。
 
 通过命名，可以使代码变得更加清晰。使用的语法也很简单，使用 typealias 关键字像普通的赋值语句一样，可以将某个在已经存在的类型赋值为新的名字。
 */
typealias LCYComicCollectionHeaderMoreActionBlock = () -> Void

class LCYRecommandHeadView: UICollectionReusableView, NibReusable {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var moreButtonClosure: LCYComicCollectionHeaderMoreActionBlock?
    
    func moreButtonClosure(_ closure: LCYComicCollectionHeaderMoreActionBlock?) {
        moreButtonClosure = closure
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        guard let moreClosure = moreButtonClosure else { return }
        moreClosure()
    }
}
