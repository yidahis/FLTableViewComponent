//
//  FLBaseComponent.swift
//  FLComponentDemo
//
//  Created by gitKong on 2017/5/17.
//  Copyright © 2017年 gitKong. All rights reserved.
//

import UIKit

let FLHeaderFooterTitleTopPadding : CGFloat = 5
let FLHeaderFooterTitleLeftPadding : CGFloat = 20

enum FLIdentifierType  : String{
    case Cell = "cell"
    case Header = "header"
    case Footer = "footer"
    
    static func type(of  reuseIdentifier : String?) -> FLIdentifierType? {
        if let reuseId = reuseIdentifier {
            if reuseId.hasSuffix(FLIdentifierType.Header.rawValue) {
                return .Header
            }
            else if reuseId.hasSuffix(FLIdentifierType.Footer.rawValue) {
                return .Footer
            }
            else {
                return .Cell
            }
        }
        return nil
    }
}

enum ComponentError: Error {
    case RegistError(String)
    case DequeueError(String)
}

extension UITableView{
    
    func registerClass(_ viewClass : AnyClass, withReuseIdentifier identifier : String){
        let identifierType = FLIdentifierType.type(of: identifier)
        if identifierType == .Header {
            self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
        }
        else if identifierType == .Footer {
            self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
        }
        else if identifierType == .Cell {
            self.register(viewClass, forCellReuseIdentifier: identifier)
        }
    }
    
    func registerNib(_ nibClass : AnyClass, withReuseIdentifier identifier : String){
        if let name = NSStringFromClass(nibClass).components(separatedBy: ".").last {
            let identifierType = FLIdentifierType.type(of: identifier)
            if identifierType == .Header {
                self.register(UINib.init(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
            }
            else if identifierType == .Footer {
                self.register(UINib.init(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
            }
            else if identifierType == .Cell {
                self.register(UINib.init(nibName: name, bundle: nil), forCellReuseIdentifier: identifier)
            }
        }
        else{
            print("Error: tableView registerNib \(nibClass) failure")
        }
    }
    
    func dequeueReusableCell<T : UITableViewCell>(withReuseIdentifier identifier: String) -> T? {
        let identifierType = FLIdentifierType.type(of: identifier)
        if identifierType == .Cell {
            return self.dequeueReusableCell(withIdentifier: identifier) as? T
        }
        else{
            return nil
        }
    }
    
    func dequeueReusableHeaderFooterView<T : FLTableViewHeaderFooterView>(withReuseIdentifier identifier: String) -> T? {
        let identifierType = FLIdentifierType.type(of: identifier)
        if identifierType == .Header {
            return self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T
        }
        else if identifierType == .Footer {
            return self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T
        }
        else{
            return nil
        }
    }
}

extension UICollectionView {
    
    func registerClass(_ viewClass: Swift.AnyClass, withReuseIdentifier identifier: String) {
        let identifierType = FLIdentifierType.type(of: identifier)
        if identifierType == .Header {
            self.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
        }
        else if identifierType == .Footer {
            self.register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier)
        }
        else if identifierType == .Cell {
            self.register(viewClass, forCellWithReuseIdentifier: identifier)
        }
    }
    
    func registerNib(_ nibClass: Swift.AnyClass, withReuseIdentifier identifier: String) {
        if let name = NSStringFromClass(nibClass).components(separatedBy: ".").last {
            let identifierType = FLIdentifierType.type(of: identifier)
            if identifierType == .Header {
                self.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier)
            }
            else if identifierType == .Footer {
                self.register(UINib.init(nibName: name, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier)
            }
            else if identifierType == .Cell {
                self.register(UINib.init(nibName: name, bundle: nil), forCellWithReuseIdentifier: identifier)
            }
        }
        else{
            print("Error: collectionView registerNib \(nibClass) failure")
        }
    }
    
    func dequeueCell(withReuseIdentifier identifier: String, forIndxPath: IndexPath) -> UICollectionViewCell? {
        let identifierType = FLIdentifierType.type(of: identifier)
        if identifierType == .Cell {
            return self.dequeueReusableCell(withReuseIdentifier: identifier, for: forIndxPath)
        }
        else{
            return nil
        }
    }
    
    func dequeueReusableHeaderFooterView<T : FLCollectionHeaderFooterView>(withReuseIdentifier identifier: String, section: Int) -> T? {
        let identifierType = FLIdentifierType.type(of: identifier)
        if identifierType == .Header {
            return self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: identifier, for: IndexPath.init(item: 0, section: section)) as? T
        }
        else if identifierType == .Footer {
            return self.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: identifier, for: IndexPath.init(item: 0, section: section)) as? T
        }
        else{
            return nil
        }
    }
}

class FLBaseComponent: NSObject, FLBaseComponentProtocol {

    var section : Int? = 0
    
    final var cellIdentifier : String {
        return "\(NSStringFromClass(type(of: self))).\(FLIdentifierType.Cell.rawValue)"
    }
    
    final var footerIdentifier: String {
        return "\(NSStringFromClass(type(of: self))).\(FLIdentifierType.Footer.rawValue)"
    }
    
    final var headerIdentifier: String {
        return "\(NSStringFromClass(type(of: self))).\(FLIdentifierType.Header.rawValue)"
    }
    
    dynamic func register() {
        // regist cell、header、footer
    }
    
}

