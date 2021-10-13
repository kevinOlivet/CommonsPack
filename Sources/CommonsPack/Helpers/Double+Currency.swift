//
//  Double+Currency.swift
//  Commons
//
//  Copyright © Jon Olivet
//

import UIKit

/// Currency display extensions
public extension Double {

    /// Display number as String with UF suffix
    func displayAsUF(
        shouldShowSign: Bool = true,
        shouldShowDecimals: Bool = true
        ) -> String {
        var showSign = shouldShowSign

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CL")
        formatter.currencySymbol = ""

        if shouldShowDecimals {
            formatter.currencyDecimalSeparator = ","
            formatter.maximumFractionDigits = 4
        }

        var sign: String

        switch self {
        case _ where self < 0:
            showSign = true
            sign = "-"
        case _ where self > 0:
            sign = "+"
        default:
            sign = ""
        }

        let symbol = " UF"

        let formattedAbsoluteValue = formatter.string(from: abs(self) as NSNumber)!

        return (showSign ? sign : "") + formattedAbsoluteValue + symbol
    }

    ///public func displayAsClp
    func displayAsClp(
        shouldShowSign: Bool = true,
        shouldShowSymbol: Bool = true,
        shouldShowDecimals: Bool = false
        ) -> String {
        var showSign = shouldShowSign

        let formatter = CommonNumberFormatter()

        if shouldShowDecimals {
            formatter.currencyDecimalSeparator = ","
            formatter.maximumFractionDigits = 4
        }

        var sign: String

        switch self {
        case _ where self < 0:
            showSign = true
            sign = "-"
        case _ where self > 0:
            sign = "+"
        default:
            sign = ""
        }

        let symbol = shouldShowSymbol ? "$ " : ""

        let formattedAbsoluteValue = formatter.string(from: abs(self) as NSNumber)!

        return (showSign ? sign : "") + symbol + formattedAbsoluteValue
    }

    ///public func displayAsUsd
    func displayAsUsd(shouldShowSign: Bool = true) -> String {
        var showSign = shouldShowSign

        let formatter = CommonNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        var sign: String

        switch self {
        case _ where self < 0:
            showSign = true
            sign = "-"
        case _ where self > 0:
            sign = "+"
        default:
            sign = ""
        }

        let symbol = "US$"

        let formattedAbsoluteValue = formatter.string(from: abs(self) as NSNumber)!

        return (showSign ? sign : "") + symbol + formattedAbsoluteValue
    }

    ///public func displayAsUsdWithDecimals
    func displayAsUsdWithDecimals(
        shouldShowSign: Bool = true,
        shouldShowUSD: Bool = true,
        decimalDigits: Int = 2) -> String {
        var showSign = shouldShowSign

        let formatter = CommonNumberFormatter()
        formatter.minimumFractionDigits = decimalDigits
        formatter.maximumFractionDigits = decimalDigits
        var sign: String

        switch self {
        case _ where self < 0:
            showSign = true
            sign = "-"
        case _ where self > 0:
            sign = "+"
        default:
            sign = ""
        }
        let symbol = "US$"
        let formattedAbsoluteValue = formatter.string(from: self as NSNumber)!
        if shouldShowUSD {
            return (showSign ? sign : "") + symbol + formattedAbsoluteValue
        } else {
            return (showSign ? sign : "") + formattedAbsoluteValue
        }
    }

    ///public func displayAsPercentage
    func displayAsPercentage(maximumFractionDigits: Int = 2) -> String {

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = maximumFractionDigits

        let formattedValue = formatter.string(from: self as NSNumber)!
        return formattedValue + "%"
    }

    ///public func displayAsTruncatedOrRoundedPercentage
    func displayAsTruncatedOrRoundedPercentage() -> String {

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        let selfShifted = self * 100.00
        let intValue = Double(Int(selfShifted))
        if (selfShifted - intValue) >= 0.5 {
            // round
            formatter.roundingMode = .ceiling
        } // else truncate

        let formattedValue = formatter.string(from: self as NSNumber)!
        return formattedValue + "%"
    }

    ///public func displayAsCommaSeparated
    func displayAsCommaSeparated(withDecimalDigits decimalDigits: Int = 0) -> String {

        let formatter = CommonNumberFormatter()
        formatter.minimumFractionDigits = decimalDigits
        formatter.maximumFractionDigits = decimalDigits
        return formatter.string(from: self as NSNumber)!
    }
}

///public extension Int
public extension Int {
    ///public func displayAsPercentage
    func displayAsPercentage() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none

        let formattedValue = formatter.string(from: self as NSNumber)!
        return formattedValue + "%"
    }

    ///public func displayAsCommaSeparated
    func displayAsCommaSeparated(withDecimalDigits decimalDigits: Int = 0) -> String {

        let formatter = CommonNumberFormatter()
        formatter.minimumFractionDigits = decimalDigits
        formatter.maximumFractionDigits = decimalDigits
        return formatter.string(from: self as NSNumber)!
    }
}

///public extension String
public extension String {
    ///func displayAsNumber
    func displayAsNumber(withLocaleIdentifier identifier: String = "es_CL") -> NSNumber? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: identifier) // es_CL for format 9.999,99
        formatter.numberStyle = .decimal
        return formatter.number(from: self as String)
    }
}
