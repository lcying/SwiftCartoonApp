//
//  LCYRankCell.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/5.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYRankCell: UITableViewCell, NibReusable {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    var rankModel: LCYRankingModel? {
        didSet {
            guard rankModel != nil else {
                return
            }
            iconImageView.kf.setImage(urlString: rankModel?.cover)
            rankLabel.text = "\(rankModel?.title ?? "")榜"
            descLabel.text = rankModel?.subTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
