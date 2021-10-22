//
//  String+Extensions.swift
//  BasicCommons
//
//

import Foundation

import Foundation

// swiftlint:disable missing_docs
// swiftlint:disable function_parameter_count
extension String {

    public var trimmedString: String {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    // swiftlint:disable localized_not_NSLocalized
    public var localized: String {
        Bundle.allBundles
            .lazy
            .map {
                    NSLocalizedString(
                        self,
                        tableName: nil,
                        bundle: $0,
                        value: self,
                        comment: ""
                    )
            }
            .first { $0 != self } ?? self
    }

    public func localized(in whichBundle: Bundle) -> String {
        Bundle.allBundles
            .filter { $0 == whichBundle }
            .lazy
            .map {
                NSLocalizedString(
                    self,
                    tableName: nil,
                    bundle: $0,
                    value: self,
                    comment: ""
                )
            }
            .first { $0 != self } ?? self
    }
    // swiftlint:enable localized_not_NSLocalized
}
