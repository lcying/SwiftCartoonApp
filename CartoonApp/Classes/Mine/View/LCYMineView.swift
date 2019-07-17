//
//  LCYMineView.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/9.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYMineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(headView)
        
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.usnp.edges).priority(.low)
            make.top.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lazy loading --------------
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.setContentOffset(CGPoint(x: 0, y: -200), animated: false)
        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    lazy var headView: LCYMineHeadView = {
        let view = LCYMineHeadView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        return view
    }()
    
    
    private lazy var myArray: Array = {
        return [[["icon":"mine_vip", "title": "我的VIP"],
                 ["icon":"mine_coin", "title": "充值妖气币"]],
                
                [["icon":"mine_accout", "title": "消费记录"],
                 ["icon":"mine_subscript", "title": "我的订阅"],
                 ["icon":"mine_seal", "title": "我的封印图"]],
                
                [["icon":"mine_message", "title": "我的消息/优惠券"],
                 ["icon":"mine_cashew", "title": "妖果商城"],
                 ["icon":"mine_freed", "title": "在线阅读免流量"]],
                
                [["icon":"mine_feedBack", "title": "帮助中心"],
                 ["icon":"mine_mail", "title": "我要反馈"],
                 ["icon":"mine_judge", "title": "给我们评分"],
                 ["icon":"mine_author", "title": "成为作者"],
                 ["icon":"mine_setting", "title": "设置"]]]
    }()
}


extension LCYMineView: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            self.headView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: -scrollView.contentOffset.y)
        } else {
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.myArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = myArray[section]
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionArray = myArray[indexPath.section]
        let dic = sectionArray[indexPath.row]
        
        cell.backgroundColor = .white
        cell.textLabel!.text = dic["title"]
        cell.imageView?.image = UIImage.init(named: dic["icon"] ?? "")
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
   
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .background
        return v
    }
    
}
