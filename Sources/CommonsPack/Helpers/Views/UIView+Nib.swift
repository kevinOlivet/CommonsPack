//
//  UIView+Nib.swift
//  Commons
//
//  Copyright © Jon Olivet
//

/// UIView utils
public extension UIView {
    ///public class func bundle
    class func bundle() -> Bundle {
        Bundle(for: self.classForCoder())
    }

    ///public class func fromNib
    class func fromNib<T: UIView>() -> T? {

        if let view: T = Utils.bundle(forClass: T.classForCoder())?.loadNibNamed(
            String(describing: T.self),
            owner: nil,
            options: nil
            )![0] as? T {
                return view
        }
        return nil
    }
}
