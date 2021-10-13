//
//  UILabelExtension.swift
//  Commons
//
//  Copyright © Jon Olivet
//

import UIKit

/// UILabel extensions
public extension UILabel {
    ///public func fadeText
    func fadeText(to text: String) {
        let initialAlpha = self.alpha
        UILabel.animate(
            withDuration: 0.2,
            animations: {
                self.alpha = 0.0
            },
            completion: { _ in
                self.text = text
                UILabel.animate( withDuration: 0.2) {
                    self.alpha = initialAlpha
                }
            }
        )
    }

    /// Spacing between lines in label
    ///
    /// - Parameters:
    ///   - lineSpacing: ParagraphStyle
    ///   - lineHeightMultiple: ParagraphStyle
    func setLineSpacing(
        lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0
        ) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else if let labelText = self.text {
            attributedString = NSMutableAttributedString(string: labelText)
        } else {
            return
        }

        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )

        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )

        self.attributedText = attributedString
    }

    // MARK: - Format text with desired spacing value between lines
    /// Add spacing value between lines
    ///
    /// - Parameter spacingValue: Spacing CGFloat Value
    func addInterlineSpacing(spacingValue: CGFloat = 2) {
        guard let textString = text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacingValue
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedText = attributedString
    }
}
