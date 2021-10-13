//
//  Alerts.swift
//  BasicCommons
//
//

import UIKit

public class Alerts {

    public static func dismissableAlert(title: String,
                                 message: String,
                                 vc: UIViewController,
                                 handler: ((UIAlertAction) -> Void)? = { _ in },
                                 actionBtnText: String,
                                 showCancelButton: Bool = false,
                                 cancelHandler: @escaping (UIAlertAction) -> Void = { _ in }) {

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        if showCancelButton {
            let dismiss = UIAlertAction(title: "CANCEL".localized,
                                        style: .cancel,
                                        handler: cancelHandler)
            alertController.addAction(dismiss)
        }
        let newAction = UIAlertAction(title: actionBtnText,
                                      style: .default,
                                      handler: handler)
        alertController.addAction(newAction)

        vc.present(alertController, animated: true, completion: nil)
    }

    ///public static func dismissableActionsheet
    public static func dismissableActionsheet(
        title: String?,
        message: String?,
        vc: UIViewController, // swiftlint:disable:this identifier_name
        handler: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let dismiss = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil)
        let exit = UIAlertAction(title: "CLOSE_SESSION".localized, style: .default, handler: handler)
        alertController.addAction(dismiss)
        alertController.addAction(exit)
        vc.present(alertController, animated: true, completion: nil)
    }

    ///public static func getTopViewController
    public static func getTopViewController() -> UIViewController {
        var viewController = UIViewController()
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            viewController = rootViewController
            var presented = rootViewController
            while let top = presented.presentedViewController {
                presented = top
                viewController = top
            }
        }
        return viewController
    }
}
