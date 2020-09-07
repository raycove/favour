//
//  PrettyViewTextView.swift
//  favour
//
//  Created by Ray Cove on 18/01/2018.
//  Copyright © 2018 Ray Cove. All rights reserved.
//

import UIKit

class PrettyViewTextView: UITextView {
    
    
    @IBInspectable var placeholder: String = ""
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray
    
    private let uiPlaceholderTextChangedAnimationDuration: Double = 0.05
    private let defaultTagValue = 999
    
    private var placeHolderLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textChanged),
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UITextView.textDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func textChanged() {
        guard !placeholder.isEmpty else {
            return
        }
        UIView.animate(withDuration: uiPlaceholderTextChangedAnimationDuration) {
            if self.text.isEmpty {
                self.viewWithTag(self.defaultTagValue)?.alpha = CGFloat(1.0)
            }
            else {
                self.viewWithTag(self.defaultTagValue)?.alpha = CGFloat(0.0)
            }
        }
    }
    
    override var text: String! {
        didSet{
            super.text = text
            textChanged()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if !placeholder.isEmpty {
            if placeHolderLabel == nil {
                placeHolderLabel = UILabel.init(frame: CGRect(x: 4, y: 8, width: bounds.size.width - 16, height: 0))
                placeHolderLabel!.lineBreakMode = .byWordWrapping
                placeHolderLabel!.numberOfLines = 0
                placeHolderLabel!.font = font
                placeHolderLabel!.backgroundColor = UIColor.clear
                placeHolderLabel!.textColor = placeholderColor
                placeHolderLabel!.alpha = 0
                placeHolderLabel!.tag = defaultTagValue
                self.addSubview(placeHolderLabel!)
            }
            
            placeHolderLabel!.text = placeholder
            placeHolderLabel!.sizeToFit()
            self.sendSubviewToBack(placeHolderLabel!)
            
            if text.isEmpty && !placeholder.isEmpty {
                viewWithTag(defaultTagValue)?.alpha = 1.0
            }
        }
        
        super.draw(rect)
    }

    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var topInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsets.init(top: topInset, left: self.contentInset.left, bottom: self.contentInset.bottom, right: self.contentInset.right)
        }
    }
    
    @IBInspectable var bottmInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsets.init(top: self.contentInset.top, left: self.contentInset.left, bottom: bottmInset, right: self.contentInset.right)
        }
    }
    
    @IBInspectable var leftInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsets.init(top: self.contentInset.top, left: leftInset, bottom: self.contentInset.bottom, right: self.contentInset.right)
        }
    }
    
    @IBInspectable var rightInset: CGFloat = 0 {
        didSet {
            self.contentInset = UIEdgeInsets.init(top: self.contentInset.top, left: self.contentInset.left, bottom: self.contentInset.bottom, right: rightInset)
        }
    }
    
    var textInsets = UIEdgeInsets.zero {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
