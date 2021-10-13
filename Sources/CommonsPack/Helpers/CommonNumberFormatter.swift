//
//  CommonNumberFormatter.swift
//  Commons
//
//  Copyright © Jon Olivet
//

import Foundation

/// Default number formatter
/// Avoid duplicate number formatter creation
public class CommonNumberFormatter: NumberFormatter {

    /// Public init with default parameters setup
    override public init() {
        super.init()
        setupFormatter()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFormatter()
    }

    func setupFormatter() {
        numberStyle = .decimal
        groupingSeparator = "."
        currencySymbol = ""
        decimalSeparator = ","
        minimumFractionDigits = 0
        maximumFractionDigits = 0
    }
}
