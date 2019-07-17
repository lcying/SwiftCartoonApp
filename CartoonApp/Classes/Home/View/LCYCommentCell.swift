//
//  LCYCommentCell.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/12.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYCommentCell: UITableViewCell, NibReusable {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headImageView.layer.cornerRadius = 20
        headImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
