//
//  LCYDetailHeadView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/12.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYDetailHeadView: UICollectionReusableView, NibReusable {
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var otherCountLabel: UILabel!
    
    var otherWorks: [LCYOtherWorkModel]?
    
    @IBAction func moreAction(_ sender: Any) {
        let vc = LCYOtherWorksController(otherWorks: otherWorks!)
        
        self.parentController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
