//
//  PrettyViewLabel.swift
//  favour
//
//  Created by Ray Cove on 16/01/2018.
//  Copyright © 2018 Ray Cove. All rights reserved.
//

import UIKit
@IBDesignable
class PrettyViewLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
    }
    
    @IBInspectable var padding: CGFloat = 0 {
        didSet {
            self.textInsets = UIEdgeInsets(top: self.padding, left: self.padding, bottom: self.padding, right: self.padding)
        }
    }
    var textInsets = UIEdgeInsets.zero {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect
    {
        var insets = self.textInsets
        let insetRect = bounds.inset(by: insets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        insets = UIEdgeInsets(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
        return textRect.inset(by: insets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.textInsets))
    }
}

