//
//  UIViewExtension.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/11.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

extension UIView {

    //返回值后面加？表示可以返回空
    func parentController() -> UIViewController? {
        var responder = self.next
        while (responder != nil) {
            if (responder?.isKind(of: UIViewController.self))! {
                return responder as? UIViewController
            }
            responder = responder?.next
        }
        return nil
    }
    
}
