//
//  LCYHomeViewController.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/1.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

class LCYHomeViewController: LCYPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        
        var value = 50.1
        var lenght = 10.2

        print("\(value)===\(lenght)")  // 此时value值为50
        
        change(value: &value,length: &lenght)
        print("\(value)===\(lenght)")
    }
    
    
    func change<T>( value: inout T, length: inout T) {
        let temp = value
        value = length
        length = temp
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        /*
         用customView创建的item位置合理，直接image创建的会靠右
         */
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"), target: self, action: #selector(searchAction))
    }

    @objc func searchAction() {
        self.navigationController?.pushViewController(LCYSearchViewController(), animated: true)
    }
    
}
