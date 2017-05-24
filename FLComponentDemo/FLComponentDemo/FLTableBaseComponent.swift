//
//  FLTableBaseComponent.swift
//  FLComponentDemo
//
//  Created by Lyon on 2017/5/11.
//  Copyright © 2017年 gitKong. All rights reserved.
//

import UIKit

let FLTableViewCellDefaultHeight : CGFloat = 44

class FLTableBaseComponent: FLBaseComponent, FLTableComponentConfiguration {
    
    var tableView : UITableView?
    
    var section : Int? = 0
    
    weak var componentController : FLTableComponentEvent?
    
    init(tableView : UITableView){
        super.init()
        self.tableView = tableView
        // regist cell or header or footer
        self.register()
    }
}

// MARK : base configuration

extension FLTableBaseComponent {
    
    override func register() {
        tableView?.registerClass(UITableViewCell.self, withReuseIdentifier: cellIdentifier)
        tableView?.registerClass(FLTableViewHeaderFooterView.self, withReuseIdentifier: headerIdentifier)
        tableView?.registerClass(FLTableViewHeaderFooterView.self, withReuseIdentifier: footerIdentifier)
    }
    
    func numberOfRows() -> NSInteger {
        return 0
    }
    
    func cellForRow(at row: Int) -> UITableViewCell {
        return (tableView?.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: IndexPath.init(row: row, section: self.section!)))!
    }
}

// MARK : header or footer customizaion

extension FLTableBaseComponent {
    
    
    /// you can override this method to perform additional operation, such as add lable or button into headerView to resue, but if you had registed the class of FLTableViewHeaderFooterView for headerView, this method will be invalid, so if you want it to be valiable, do not call super when you override register() method
    ///
    /// - Parameter headerView:  headerView for ready to reuse
    func additionalOperationForReuseHeaderView(_ headerView : FLTableViewHeaderFooterView?) {
        // do something , such as add lable or button into headerView or footerView to resue
    }
    
    
    /// you can override this method to perform additional operation, such as add lable or button into footerView to resue, but if you had registed the class of FLTableViewHeaderFooterView for footerView, this method will be invalid, so if you want it to be valiable, do not call super when you override register() method
    ///
    /// - Parameter footerView: footerView for ready to reuse
    func additionalOperationForReuseFooterView(_ footerView : FLTableViewHeaderFooterView?) {
        
    }
    
    
    /// when you override this method, you should call super to get headerView if you just regist the class of FLTableViewHeaderFooterView; if you override the method of register() to regist the subclass of FLTableViewHeaderFooterView, you can not call super to get headerView, and you should call init(reuseIdentifier: String?, section: Int) and addClickDelegete(for headerFooterView : FLTableViewHeaderFooterView?)  if this headerView have to accurate tapping event
    ///
    /// - Parameter section: current section
    /// - Returns: FLTableViewHeaderFooterView
    func headerView() -> FLTableViewHeaderFooterView? {
        var headerView = tableView?.dequeueReusableHeaderFooterView(withReuseIdentifier: self.headerIdentifier)
        // MARK : if subclass override headerView(at section: Int) method , also override register() and do nothing in it, so headerView will be nil, then create the new one to reuse it
        if (headerView == nil) {
            // MARK : if you want header or footer view have accurate event handling capabilities, you should initialize with init(reuseIdentifier: String?, section: Int)
            headerView = FLTableViewHeaderFooterView.init(reuseIdentifier: self.headerIdentifier,section: section!)
            additionalOperationForReuseHeaderView(headerView)
        }
        if let headerTitle = self.titleForHeader() {
            headerView?.titleLabel.attributedText = headerTitle
        }
        addClickDelegete(for: headerView)
        headerView?.section = section
        return headerView
    }
    
    /// when you override this method, you should call super to get footerView if you just regist the class of FLTableViewHeaderFooterView; if you override the method of register() to regist the subclass of FLTableViewHeaderFooterView, you can not call super to get headerView, and you should call init(reuseIdentifier: String?, section: Int) and addClickDelegete(for headerFooterView : FLTableViewHeaderFooterView?)  if this footerView have to accurate tapping event
    ///
    /// - Returns: FLTableViewHeaderFooterView
    func footerView() -> FLTableViewHeaderFooterView? {
        var footerView = tableView?.dequeueReusableHeaderFooterView(withReuseIdentifier: footerIdentifier)
        if (footerView == nil) {
            // MARK : if you want header or footer view have accurate event handling capabilities, you should initialize with init(reuseIdentifier: String?, section: Int)
            footerView = FLTableViewHeaderFooterView.init(reuseIdentifier: self.footerIdentifier,section: section!)
            additionalOperationForReuseFooterView(footerView)
        }
        if let footerTitle = self.titleForFooter() {
            footerView?.titleLabel.attributedText = footerTitle
        }
        addClickDelegete(for: footerView)
        footerView?.section = section
        return footerView
    }
    
    func titleForHeader() -> NSMutableAttributedString? {
        return nil
    }
    
    func titleForFooter() -> NSMutableAttributedString? {
        return nil
    }
    
    private func addClickDelegete(for headerFooterView : FLTableViewHeaderFooterView?)  {
        headerFooterView?.delegate = componentController
    }
}

// MARK : height customization

extension FLTableBaseComponent {
    
    func heightForRow(at row: Int) -> CGFloat {
        return FLTableViewCellDefaultHeight
    }
    
    func heightForHeader() -> CGFloat {
        if let headerTitle = self.titleForHeader() {
            return suitableTitleHeight(forString: headerTitle)
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func heightForFooter() -> CGFloat {
        if let footerTitle = self.titleForFooter() {
            return suitableTitleHeight(forString: footerTitle)
        }
        return CGFloat.leastNormalMagnitude
    }
    
    private func suitableTitleHeight(forString string : NSMutableAttributedString) -> CGFloat{
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect = string.boundingRect(with: CGSize.init(width: UIScreen.main.bounds.width - 2 * FLHeaderFooterTitleLeftPadding, height: CGFloat.greatestFiniteMagnitude), options: option, context: nil)
        // footer or header height must higher than the real rect for footer or header title,otherwise, footer or header title will offset
        return rect.height + FLHeaderFooterTitleTopPadding * 2
    }
}

// MARK : Display customization

extension FLTableBaseComponent {
    func tableView(willDisplayCell cell: UITableViewCell, at row: Int){
        // do nothing
    }
    
    func tableView(didEndDisplayCell cell: UITableViewCell, at row: Int){
        
    }
    
    func tableView(willDisplayHeaderView view: FLTableViewHeaderFooterView){
        
    }
    
    func tableView(willDisplayFooterView view: FLTableViewHeaderFooterView){
        
    }
    
    func tableView(didEndDisplayHeaderView view: FLTableViewHeaderFooterView){
        
    }
    
    func tableView(didEndDisplayFooterView view: FLTableViewHeaderFooterView){
        
    }
}




