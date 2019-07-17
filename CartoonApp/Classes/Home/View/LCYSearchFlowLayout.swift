//
//  LCYSearchFlowLayout.swift
//  CartoonApp
//
//  Created by 刘岑颖 on 2019/7/8.
//  Copyright © 2019 lcy. All rights reserved.
//

import UIKit

protocol UICollectionViewDelegateLeftAlignedLayout: UICollectionViewDelegateFlowLayout {
    
}

extension UICollectionViewLayoutAttributes {
    func leftAlignFrame(with sectionInset: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}

class LCYSearchFlowLayout: UICollectionViewFlowLayout {

    //layoutAttributesForElementsInRect方法 ---------------
    /*
     rect初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定。
     返回在collectionView的可见范围内(bounds)所有item对应的layoutAttrure对象装成的数组。collectionView的每个item都对应一个专门的UICollectionViewLayoutAttributes类型的对象来表示该item的一些属性，比如bounds,size,transform,alpha等。
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        let updatedAttributes = NSMutableArray.init(array: originalAttributes)
        
        for attribute in originalAttributes {
            /*
             @property(nonatomic, readonly) UICollectionElementCategory representedElementCategory;
             Item的类型。
             你可以使用这个属性的值来区分这个布局属性是用于一个Cell还是Supplementary View还是Decoration View。
             
             
             @property(nonatomic, readonly) NSString *representedElementKind;
             目标视图的布局指定标识符。
             你可以使用这个属性的值来标识Supplementary View或者Decoration View相关联的属性给定的目的。如果representedElementCategory属性为UICollectionElementCategoryCell，那么这个属性为nil。
             */
            if (attribute.representedElementKind == nil) {
                let index = updatedAttributes.index(of: attribute)
                //layoutAttributesForItemAtIndexPath:返回对应于indexPath的位置的cell的布局属性，这个方法被重写了
                updatedAttributes[index] = self.layoutAttributesForItem(at: attribute.indexPath) as Any
            }
        }
        
        return (updatedAttributes as! [UICollectionViewLayoutAttributes])
    }
    
    //重写了
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        //当前的UICollectionViewLayoutAttributes
        let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as! UICollectionViewLayoutAttributes

        let sectionInset = self.evaluatedSectionInsetForItem(at: indexPath.section)
        
        let isFirstItemInSection: Bool = indexPath.item == 0
        //如果是第一个那就直接返回就行
        if isFirstItemInSection {
            currentItemAttributes.leftAlignFrame(with:sectionInset)
            return currentItemAttributes
        }
        
        let layoutWidth: CGFloat = (self.collectionView?.frame.size.width)! - sectionInset.left - sectionInset.right
        
        let previousIndexPath = NSIndexPath.init(item: indexPath.item - 1, section: indexPath.section)
        
        let previousFrame = self.layoutAttributesForItem(at: previousIndexPath as IndexPath)?.frame
        
        let previousFrameRightPoint = (previousFrame?.origin.x)! + previousFrame!.size.width
        
        let currentFrame = currentItemAttributes.frame
        
        let strecthedCurrentFrame = CGRect(x: sectionInset.left, y: currentFrame.origin.y, width: layoutWidth, height: currentFrame.size.height)
        
        //如果不想交说明是这一行的第一个
        let isFirstItemInRow = !previousFrame!.intersects(strecthedCurrentFrame)
        
        if isFirstItemInRow {
            currentItemAttributes.leftAlignFrame(with: sectionInset)
            return currentItemAttributes
        }
        
        //放到之前的item的右侧
        
        var frame = currentItemAttributes.frame
        frame.origin.x = previousFrameRightPoint + self.evaluatedMinimumInteritemSpacingForSection(at: indexPath.section)
        
        currentItemAttributes.frame = frame
        
        return currentItemAttributes
        
    }
    
    // 计算section的inset
    func evaluatedSectionInsetForItem(at index: NSInteger) -> UIEdgeInsets {

        if (self.collectionView?.delegate?.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))))! {
            
            let delegate = self.collectionView?.delegate as! UICollectionViewDelegateLeftAlignedLayout
            
            return (delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: index))!
            
        } else {
            return sectionInset
        }
        
    }
    
    func evaluatedMinimumInteritemSpacingForSection(at index: NSInteger) -> CGFloat {
        if (self.collectionView?.delegate?.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))))! {
            let delegate = self.collectionView?.delegate as! UICollectionViewDelegateFlowLayout
            return (delegate.collectionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: index))!
        } else {
            return self.minimumInteritemSpacing
        }
    }
    
}
