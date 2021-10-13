//
//  LogInViewController.swift
//  BasicCommons
//
//

import UIKit

public class KeyboardConstraint: NSLayoutConstraint {

    var offset: CGFloat = 0
    var keyboardHeight: CGFloat = 0
    var shouldExecuteAnimation = true

    override public func awakeFromNib() {
        offset = constant
        super.awakeFromNib()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyboardConstraint.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(KeyboardConstraint.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                keyboardHeight = frame.size.height
            }
            self.updateConstant()
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
            let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            switch (animationDuration, animationCurve) {
            case let (.some(duration), .some(curve)):
                let options = UIView.AnimationOptions(rawValue: curve.uintValue)
                UIView.animate(
                    withDuration: TimeInterval(duration.doubleValue),
                    delay: 0,
                    options: options,
                    animations: {
                        UIApplication.shared.keyWindow?.layoutIfNeeded()
                        return
                    }
                )
            default:
                return
            }
        }
    }

    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        keyboardHeight = 0
        self.updateConstant()
        if let userInfo = notification.userInfo {
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
            let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            switch (animationDuration, animationCurve) {
            case let (.some(duration), .some(curve)):
                let options = UIView.AnimationOptions(rawValue: curve.uintValue)
                if shouldExecuteAnimation {
                    UIView.animate(
                        withDuration: TimeInterval(duration.doubleValue),
                        delay: 0,
                        options: options,
                        animations: {
                            UIApplication.shared.keyWindow?.layoutIfNeeded()
                            return
                        }
                    )
                }
            default:
                return
            }
        }
    }

    func updateConstant() {
        self.constant = offset + keyboardHeight
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

public class Utils: NSObject {

    static func appendActivityTo(view: UIView) -> UIActivityIndicatorView {
        let aiv = UIActivityIndicatorView(style: .gray)
        aiv.startAnimating()
        aiv.center = view.center
        aiv.hidesWhenStopped = true
        view.addSubview(aiv)
        return aiv
    }

    public class func bundle(forClass: Swift.AnyClass) -> Bundle? {
        let frameworkBundle = Bundle(for: forClass)
        if let bundleURL = frameworkBundle.urls(forResourcesWithExtension: "bundle", subdirectory: nil)?.first {
            return Bundle(url: bundleURL)
        }
        return frameworkBundle
    }

    public class func pathForJSON(resourceName: String, fromClass: Swift.AnyClass) -> String {
        let resourceBundle = Utils.bundle(forClass: fromClass)
        return (resourceBundle?.path(forResource: resourceName, ofType: "json"))!
    }
}
