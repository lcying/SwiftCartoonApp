//
//  LCYCategoryRankswift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/10.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit
import Reusable

class LCYCategoryRankCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var showImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var rankImageView: UIImageView!
    
    //用这个判断tagLabel和rankImageView
    var defaultConTagType: String?
    
    var model: LCYComicModel? {
        didSet {
            guard let model = model else {
                return
            }
            
            showImageView.kf.setImage(urlString: model.cover)
            nameLabel.text = model.name
            typeLabel.text = "\(model.tags?.joined(separator: " ") ?? "") | \(model.author ?? "")"
            descLabel.text = model.description
            
            
            if self.defaultConTagType == "更新时间" {
                print("contag = \(model.conTag)")
                let comicDate = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(model.conTag)))
                var tagString = ""
                if comicDate < 60 {
                    tagString = "\(Int(comicDate))秒前"
                } else if comicDate < 3600 {
                    tagString = "\(Int(comicDate / 60))分前"
                } else if comicDate < 86400 {
                    tagString = "\(Int(comicDate / 3600))小时前"
                } else if comicDate < 31536000{
                    tagString = "\(Int(comicDate / 86400))天前"
                } else {
                    tagString = "\(Int(comicDate / 31536000))年前"
                }
                tagLabel.text = tagString
                
                rankImageView.isHidden = true
                
            } else {
                
                var tagString = ""
                if model.conTag > 100000000 {
                    tagString = String(format: "%.1f亿", Double(model.conTag) / 100000000)
                } else if model.conTag > 10000 {
                    tagString = String(format: "%.1f万", Double(model.conTag) / 10000)
                } else {
                    tagString = "\(model.conTag)"
                }
                if tagString != "0" {
                    tagLabel.text = "\(defaultConTagType ?? "总点击") \(tagString)"
                }
                
                rankImageView.isHidden = false
                
            }
            
        }
    }
    
    var indexPath: IndexPath? {
        didSet {
            guard let indexPath = indexPath else { return }
            if indexPath.row < 3 {
                rankImageView.image = UIImage.init(named: "rank_\(indexPath.row)")
            } else {
                rankImageView.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.rankImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
