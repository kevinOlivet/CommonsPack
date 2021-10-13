//
//  Bundle+Extension.swift
//  BasicCommons
//
//

import Foundation

/// Auxiliar Extension to access Modules Bundles
public extension Bundle {
    // swiftlint:disable identifier_name
    enum Project: String, CaseIterable {
        case BasicCommons
        case BankUnited
        case CuotasModule

        internal var identifier: String {
            "org.cocoapods.\(self.rawValue)"
        }
    }
    // swiftlint:enable identifier_name

    /// Get Main Bundles
    static var projectBundles: [Bundle] {
        enum Holder {
            static var bundles: [Bundle] = []
        }

        if Holder.bundles.isEmpty {
            let identifiers = Set(Project.allCases.map { $0.identifier })
            Holder.bundles = Bundle.allFrameworks.filter {
                $0.bundleIdentifier.map { identifiers.contains($0) } ?? false
            }
        }

        return Holder.bundles
    }
}
