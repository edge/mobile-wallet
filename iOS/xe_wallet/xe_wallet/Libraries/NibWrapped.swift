//
//  NibWrapped.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit

@propertyWrapper @dynamicMemberLookup public struct NibWrapped<T: UIView> {
    
    public init(_ type: T.Type) { }
    
    public var wrappedValue: UIView!
    
    public var unwrapped: T { (wrappedValue as! NibWrapperView<T>).contentView }

    public subscript<U>(dynamicMember keyPath: KeyPath<T,U>) -> U { unwrapped[keyPath: keyPath] }

    public subscript<U>(dynamicMember keyPath: WritableKeyPath<T,U>) -> U {
        
        get { unwrapped[keyPath: keyPath] }
        set {
            
            var unwrappedView = unwrapped
            unwrappedView[keyPath: keyPath] = newValue
        }
    }
}
