//
//  UIViewController+Extensions.swift
//  BasicCommons
//
//

import UIKit

public extension UIViewController{

    func showModalLoadingView() -> UIActivityIndicatorView {
        
        // User cannot interact with the app while the loadingView is visible
        UIApplication.shared.beginIgnoringInteractionEvents()

        var indicator = UIActivityIndicatorView()

        indicator = UIActivityIndicatorView(frame: self.view.frame)
        indicator.center = self.view.center
        indicator.style = .whiteLarge
        indicator.color = UIColor.black
        indicator.hidesWhenStopped = true
        indicator.startAnimating()

        self.view.addSubview(indicator)

        return indicator
    }

    // Hides the loading indicator and enables user interaction with the app
    func hideModalLoadingView(indicator: UIActivityIndicatorView){

        indicator.stopAnimating()
        indicator.isHidden = true

        // user can interact again with the app
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
