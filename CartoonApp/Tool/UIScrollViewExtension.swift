//
//  UIScrollViewExtension.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/5.
//  Copyright © 2019 lcy. All rights reserved.
//

import Foundation
import EmptyDataSet_Swift

extension UIScrollView {
    /*
     众所周知, 在Swift的扩展(Extension)中只能添加计算属性, 但是有时候, 我们需要添加存储属性的话, 就用到了Runtime的方法.
     */
    public struct AssoicatedKeys {
        static var EmptyKey: Void?
        static var HeaderKey: Void?
    }
    
    // MARK: - 空数据页面 -----------------------
    
    var emptyView: EmptyView? {
        set {
            self.emptyDataSetSource = newValue
            self.emptyDataSetDelegate = newValue
            // 第一个参数：给哪个对象添加关联
            // 第二个参数：关联的key，通过这个key获取
            // 第三个参数：关联的value
            // 第四个参数：关联的策略
            objc_setAssociatedObject(self, &AssoicatedKeys.EmptyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            // 根据关联的key，获取关联的值。
            return objc_getAssociatedObject(self, &AssoicatedKeys.EmptyKey) as? EmptyView
        }
    }

}

class EmptyView: EmptyDataSetSource, EmptyDataSetDelegate {
    //为EmptyView定义的参数
    var image: UIImage?
    var verticalOffset: CGFloat = 0
    var allowShow: Bool = false
    //点击view的闭包
    private var tapClosure: (() -> Void)?
    
    init(image: UIImage? = UIImage.init(named: "nodata"), verticalOffset: CGFloat = 0, tapClosure: (() -> Void)?) {
        self.image = image
        self.tapClosure = tapClosure
        self.verticalOffset = verticalOffset
    }
    
    //EmptyDataSetSource ----
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return image
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return verticalOffset
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return allowShow
    }
    //EmptyDataSetDelegate ----
    internal func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        guard let tapClosure = tapClosure else { return }
        tapClosure()
    }
}
