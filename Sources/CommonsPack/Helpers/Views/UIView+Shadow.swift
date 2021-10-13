//
//  UIView+Shadow.swift
//  Commons
//
//  Copyright © Jon Olivet
//

/// UIView shadow
public extension UIView {

    ///public func dropShadow
    /// - Parameters:
    ///     - scale: The scale of shadow
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // swiftlint:disable function_default_parameter_at_end
    /// public func dropShadow
    /// - Parameters:
    ///     - color: The color of shadow
    ///     - opacity: The opacity of shadow
    ///     - offSet: The offset of shadow
    ///     - radius: The radius of shadow
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
    }

}
