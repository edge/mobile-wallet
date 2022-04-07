//
//  NibWrapperView.swift
//  xe_wallet
//
//  Created by Paul Davis on 07/10/2021.
//

import UIKit

class NibWrapperView<T: UIView>: UIView {

    var contentView: T

    required init?(coder: NSCoder) {
        
        contentView = T.loadFromNib()
        super.init(coder: coder)
        prepareContentView()
    }
    
    override init(frame: CGRect) {
        
        contentView = T.loadFromNib()
        super.init(frame: frame)
        prepareContentView()
    }
    
    private func prepareContentView() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func prepareForInterfaceBuilder() {
        
        super.prepareForInterfaceBuilder()
        contentView.prepareForInterfaceBuilder()
    }
}
