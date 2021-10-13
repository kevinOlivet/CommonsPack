//
//  UIView+IBDesignables.swift
//  Commons
//
//  Copyright © Jon Olivet
//

import UIKit

/// UIView utils
public extension UIView {

    /// public var cornerRadius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    /// public var borderWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    // swiftlint:disable uitheme_not_UIColor
    /// public var borderColor
    @IBInspectable var borderColor: UIColor? {
        get {
            UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
