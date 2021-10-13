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
        Bundle.projectBundles
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

    public func localized(in whichBundle: Bundle.Project) -> String {
        Bundle.projectBundles
            .filter { $0.bundleIdentifier == whichBundle.identifier }
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
