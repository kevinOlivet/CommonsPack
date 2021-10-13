//
//  UIView+Tap.swift
//  BasicCommons
//
//

import UIKit

// MARK: - Helper for view extends taps gesture.

/// UIView utils
public extension UIView {

    /// Associates a target object and action method with current control using a tap gesture.
    ///
    /// - Parameters:
    ///   - target: The target object—that is, the object whose action method is called.
    ///   - action: A selector identifying the action method to be called.
    func addTapAction(target: Any?, action: Selector) {
        let tap = UITapGestureRecognizer(
            target: target,
            action: action
        )
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }

    /// Associates a target object and action method with current control using a tap gesture, but only on debug mode
    ///
    /// - Parameters:
    ///   - target: The target object—that is, the object whose action method is called.
    ///   - action: A selector identifying the action method to be called.
    ///   - numberOfTapsRequired: the number of taps required to trigger the action, default = 4
    func addTapActionDebug(target: Any?, action: Selector, numberOfTapsRequired: Int = 4 ) {
        //if DEBUG to avoid warnings with _isDebugAssertConfiguration
        #if DEBUG
            let tap = UITapGestureRecognizer(
                target: target,
                action: action
            )
            tap.numberOfTapsRequired = numberOfTapsRequired
            tap.cancelsTouchesInView = false
            self.addGestureRecognizer(tap)
        #endif
    }
}
