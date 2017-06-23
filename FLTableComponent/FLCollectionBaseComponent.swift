//
//  FLCollectionBaseComponent.swift
//  FLComponentDemo
//
//  Created by gitKong on 2017/5/17.
//  Copyright © 2017年 gitKong. All rights reserved.
//

import UIKit

class FLCollectionBaseComponent: FLBaseComponent, FLCollectionComponentConfiguration{
    
    var collectionView : UICollectionView?
    
    weak var componentController : FLCollectionComponentEvent?
    
    init(collectionView : UICollectionView){
        super.init()
        self.collectionView = collectionView
        // regist cell or header or footer
        self.register()
    }
}

// MARK : base configuration

extension FLCollectionBaseComponent {
    
    override func register() {
        collectionView?.registerClass(FLCollectionViewCell.self, withReuseIdentifier: cellIdentifier)
        collectionView?.registerClass(FLCollectionHeaderFooterView.self, withReuseIdentifier: headerIdentifier)
        collectionView?.registerClass(FLCollectionHeaderFooterView.self, withReuseIdentifier: footerIdentifier)
    }
    
    func numberOfItems() -> NSInteger {
        return 0
    }
    
    func cellForItem(at item: Int) -> UICollectionViewCell {
        guard let collectionView = collectionView else {
            return FLCollectionViewCell()
        }
        FLCollectionViewCell.component = self
        
        return collectionView.dequeueCell(withReuseIdentifier: cellIdentifier, forIndxPath: IndexPath.init(row: item, section: section!))!
    }
    
    func additionalOperationForReuseCell(_ cell : FLCollectionViewCell?) {
        
    }
    
    
    /// If you do not override this method, the flow layout uses the values in its itemSize property to set the size of items instead. Your implementation of this method can return a fixed set of sizes or dynamically adjust the sizes based on the cell’s content.
    ///
    /// - Parameters:
    ///   - collectionViewLayout: Default is flowLayout
    ///   - indexPath: current indexPath
    /// - Returns: item size,default is (50.0, 50.0)
    func sizeForItem(at item: Int) -> CGSize {
        guard self.collectionView != nil, self.collectionView?.collectionViewLayout is FLCollectionViewFlowLayout else {
            return .zero
        }
        let flowLayout = self.collectionView!.collectionViewLayout as! FLCollectionViewFlowLayout
        return flowLayout.itemSize
    }
    
    
}

// MARK : Header and Footer customization

extension FLCollectionBaseComponent {
    
    func heightForHeader() -> CGFloat {
        return 0
    }
    
    func heightForFooter() -> CGFloat {
        return 0
    }
    
    func headerView() -> FLCollectionHeaderFooterView {
        guard let collectionView = collectionView ,let section = section else {
            return FLCollectionHeaderFooterView(frame: .zero)
        }
        FLCollectionHeaderFooterView.type = .Header
        FLCollectionHeaderFooterView.component = self
        
        let headerView = collectionView.dequeueReusableHeaderFooterView(withReuseIdentifier: headerIdentifier, section: section)
        
        return headerView!
    }
    
    func footerView() -> FLCollectionHeaderFooterView {
        guard let collectionView = collectionView, let section = section else {
            return FLCollectionHeaderFooterView(frame: CGRect.zero)
        }
        FLCollectionHeaderFooterView.type = .Footer
        FLCollectionHeaderFooterView.component = self
        
        let footerView = collectionView.dequeueReusableHeaderFooterView(withReuseIdentifier: footerIdentifier, section: section)
        return footerView!
    }
    
    func additionalOperationForReuseHeaderView(_ headerView : FLCollectionHeaderFooterView?) {
        
    }
    
    func additionalOperationForReuseFooterView(_ footerView : FLCollectionHeaderFooterView?) {
        
    }
    
    final func collectionView(viewOfKind kind: String) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            return self.headerView()
        }
        else if kind == UICollectionElementKindSectionFooter {
            return self.footerView()
        }
        else {
            return UICollectionReusableView()
        }
    }
}

// MARK : Base UI Customization

extension FLCollectionBaseComponent {
    
    func sectionInset() -> UIEdgeInsets {
        guard self.collectionView != nil, self.collectionView?.collectionViewLayout is FLCollectionViewFlowLayout else {
            return .zero
        }
        let flowLayout = self.collectionView!.collectionViewLayout as! FLCollectionViewFlowLayout
        return flowLayout.sectionInset
    }
    
    func minimumLineSpacing() -> CGFloat {
        guard self.collectionView != nil, self.collectionView?.collectionViewLayout is FLCollectionViewFlowLayout else {
            return 0
        }
        let flowLayout = self.collectionView!.collectionViewLayout as! FLCollectionViewFlowLayout
        return flowLayout.minimumLineSpacing
    }
    
    func minimumInteritemSpacing() -> CGFloat {
        guard self.collectionView != nil, self.collectionView?.collectionViewLayout is FLCollectionViewFlowLayout else {
            return 0
        }
        let flowLayout = self.collectionView!.collectionViewLayout as! FLCollectionViewFlowLayout
        return flowLayout.minimumInteritemSpacing
    }
}


extension FLCollectionBaseComponent {
    
    func collectionView(willDisplayCell cell: UICollectionViewCell, at item: Int) {
        // do nothing
    }
    
    func collectionView(didEndDisplayCell cell: UICollectionViewCell, at item: Int) {
        
    }
    
    func collectionView(willDisplayHeaderView view: FLCollectionHeaderFooterView) {
        
    }
    
    func collectionView(didEndDisplayHeaderView view: FLCollectionHeaderFooterView) {
        
    }
    
    func collectionView(willDisplayFooterView view: FLCollectionHeaderFooterView) {
        
    }
    
    func collectionView(didEndDisplayFooterView view: FLCollectionHeaderFooterView) {
        
    }
    
    final func collectionView(willDisplayView view : FLCollectionHeaderFooterView, viewOfKind kind: String) {
        
        if kind == UICollectionElementKindSectionHeader {
            self.collectionView(willDisplayHeaderView: view)
        }
        else if kind == UICollectionElementKindSectionFooter {
            self.collectionView(willDisplayHeaderView: view)
        }
    }
    
    final func collectionView(didEndDisplayView view : FLCollectionHeaderFooterView, viewOfKind kind: String) {
        
        if kind == UICollectionElementKindSectionHeader {
            self.collectionView(didEndDisplayHeaderView: view)
        }
        else if kind == UICollectionElementKindSectionFooter {
            self.collectionView(didEndDisplayHeaderView: view)
        }
    }
}


extension FLCollectionBaseComponent {
    
    func shouldShowMenu(at item: Int) -> Bool {
        return false
    }
    
    func canPerform(selector : Selector, forItemAt: Int, withSender: Any?) -> Bool {
        return false
    }
    
    func perform(selector : Selector, forItemAt: Int, withSender: Any?) {
        // do nothing
    }
}

