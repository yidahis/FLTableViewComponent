//
//  FLTableViewHandler.swift
//  FLComponentDemo
//
//  Created by 孔凡列 on 2017/6/16.
//  Copyright © 2017年 YY Inc. All rights reserved.
//

import UIKit

@objc protocol FLTableViewHandlerDelegate {
    @objc optional func tableViewDidClick(_ handler : FLTableViewHandler, cellAt indexPath : IndexPath)
    @objc optional func tableViewDidClick(_ handler : FLTableViewHandler, headerAt section : NSInteger)
    @objc optional func tableViewDidClick(_ handler : FLTableViewHandler, footerAt section : NSInteger)
}

class FLTableViewHandler: NSObject {
    
    var components : Array<FLTableBaseComponent> = []
    
    weak var delegate : FLTableViewHandlerDelegate?
    
    var tableView : UITableView? {
        return components.first?.tableView
    }
    
    func cellForRow(at indexPath : IndexPath) -> UITableViewCell? {
        return self.tableView?.cellForRow(at:indexPath)
    }
    
    func headerView(forSection section: Int) -> FLTableViewHeaderFooterView? {
        let header = tableView?.headerView(forSection: section) as? FLTableViewHeaderFooterView
        return header
    }
    
    func footerView(forSection section: Int) -> FLTableViewHeaderFooterView? {
        let footer = tableView?.footerView(forSection: section) as? FLTableViewHeaderFooterView
        return footer
    }
    
}

extension FLTableViewHandler :  UITableViewDataSource {
    final func numberOfSections(in tableView: UITableView) -> Int {
        return components.count
    }
    
    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard components.count > 0 else {
            return 0
        }
        return components[section].numberOfRows()
    }
    
    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard components.count > 0 else {
            return UITableViewCell()
        }
        let component : FLTableBaseComponent = components[indexPath.section]
        component.section = indexPath.section
        return component.cellForRow(at: indexPath.row)
    }
}

// MARK : header or footer customizaion

extension FLTableViewHandler {
    
    final func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        guard components.count > 0 else {
            return nil
        }
        let component = components[section]
        component.handler = self
        return component.headerView()
    }
    
    final func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        guard components.count > 0 else {
            return nil
        }
        let component = components[section]
        component.handler = self
        return component.footerView()
    }
}

// MARK : Hight customization

extension FLTableViewHandler {
    
    final func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        guard components.count > 0 else {
            return 0
        }
        return components[indexPath.section].heightForRow(at: indexPath.row)
    }
    
    final func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        guard components.count > 0 else {
            return 0
        }
        return components[section].heightForHeader()
    }
    
    final func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        guard components.count > 0 else {
            return 0
        }
        return components[section].heightForFooter()
    }
    
}

// MARK : Display customization

extension FLTableViewHandler {
    
    final func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        guard components.count > 0 else {
            return
        }
        components[indexPath.section].tableView(willDisplayCell: cell, at: indexPath.row)
    }
    
    final public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        guard components.count > 0 else {
            return
        }
        components[indexPath.section].tableView(didEndDisplayCell: cell, at: indexPath.row)
    }
    
    final public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        guard components.count > 0 else {
            return
        }
        components[section].tableView(willDisplayHeaderView: (view as? FLTableViewHeaderFooterView)!)
    }
    
    final public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        guard components.count > 0 else {
            return
        }
        components[section].tableView(willDisplayFooterView: (view as? FLTableViewHeaderFooterView)!)
    }
    
    final public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int){
        guard components.count > 0 else {
            return
        }
        components[section].tableView(didEndDisplayHeaderView: (view as? FLTableViewHeaderFooterView)!)
    }
    
    final public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int){
        guard components.count > 0 else {
            return
        }
        components[section].tableView(didEndDisplayFooterView: (view as? FLTableViewHeaderFooterView)!)
    }
}


// MARK : Event

extension FLTableViewHandler : UITableViewDelegate, FLTableComponentEvent {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.tableViewDidClick?(self, cellAt: indexPath)
    }
    
    func tableHeaderView(_ headerView: FLTableViewHeaderFooterView, didClickSectionAt section: Int) {
        self.delegate?.tableViewDidClick?(self, headerAt: section)
    }
    
    func tableFooterView(_ footerView: FLTableViewHeaderFooterView, didClickSectionAt section: Int) {
        self.delegate?.tableViewDidClick?(self, footerAt : section)
    }
}

