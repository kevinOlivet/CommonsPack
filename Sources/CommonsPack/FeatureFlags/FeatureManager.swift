//
//  FeatureManager.swift
//  BasicCommons
//
//  Copyright © Jon Olivet. All rights reserved.
//

import Foundation

// swiftlint:disable missing_docs
public typealias Scheme = String
public typealias Module = String
public typealias Feature = String

/// Class responsible of managing the Feature Flags for the App.
public class FeatureManager {
    public enum BuildScheme: String {
        case debug = "main-dev"
        case integration = "main-int"
        case local = "main-loc"
        case production = "main-prod"
        case qa = "main-qa" // swiftlint:disable:this identifier_name
    }

    /// Namespace for the Features used for registering and reading the Features flags values
    public enum Modules: String {
        case mainApp
        case basicCommons
        case bankUnited
        case cuotasModule
    }

    private var featureFlags: [Scheme: [Module: [Feature: Any]]]

    /// An instance of Feature Manager that lets you access or add Feature Flagas Values
    public static let instance = FeatureManager()

    private init() {
        featureFlags = [:]
    }

    private func modules(forScheme: FeatureManager.BuildScheme) -> [Module: [Feature: Any]] {
        featureFlags.value(
            for: forScheme.rawValue,
            default: [:]
        )
    }

    private func definedFeatureFlags(forScheme scheme: FeatureManager.BuildScheme,
                                     forModule: FeatureManager.Modules) -> [Feature: Any] {
        self.modules(forScheme: scheme).value(
            for: forModule.rawValue,
            default: [:]
        )
    }

    /// Set or updates Feature Toggle Values
    ///
    /// - Parameters:
    ///   - features: list of features you want to add.
    ///   - forModule: name of the module that owns this list of features. By default sets the App as the Module
    public func setFeatureFlags(features: [Feature: Any] = [:],
                                onScheme schemes: [FeatureManager.BuildScheme] = [.debug],
                                forModule module: FeatureManager.Modules = Modules.mainApp) {

        for scheme in schemes {
            var featureFlagsForModule: [Feature: Any] = definedFeatureFlags(
                forScheme: scheme,
                forModule: module
            )

            for (key, value) in features {
                featureFlagsForModule.updateValue(value, forKey: key)
            }

            var featureFlagsForScheme = modules(forScheme: scheme)
            featureFlagsForScheme.updateValue(featureFlagsForModule, forKey: module.rawValue)

            featureFlags.updateValue(featureFlagsForScheme, forKey: scheme.rawValue)
        }
    }

    /// Get a value for a key or set de default value that you send if it doesn't exist
    ///
    /// - Parameters:
    ///   - key: name for the feature
    ///   - inModule: module to which the feature belongs to
    ///   - default: value to assign to your feature flag in case there is not a register on Manager
    /// - Returns: the value for your feature if there is one registered or your default
    public func value<V>(
        for key: String,
        onScheme scheme: FeatureManager.BuildScheme? = FeatureManager.BuildScheme(
            rawValue: Configuration.App.appDisplayName
        ),
        inModule module: FeatureManager.Modules? = Modules.mainApp,
        default defaultExpression: @autoclosure () -> V) -> V {

        let featureFlagsForModule: [Feature: Any] = definedFeatureFlags(
            forScheme: scheme!,
            forModule: module!
        )
        return featureFlagsForModule.value(for: key, default: defaultExpression())
    }

    /// Get a String value for a key or EMPTY if it doesn't exist
    ///
    /// - Parameters:
    ///   - key: name for the feature
    ///   - inModule: module to which the feature belongs to
    /// - Returns: the value for your feature if there is one registered or an Empty String
    public func value(
        for key: String,
        onScheme scheme: FeatureManager.BuildScheme? = FeatureManager.BuildScheme(
                rawValue: Configuration.App.appDisplayName
        ),
        inModule module: FeatureManager.Modules? = Modules.mainApp) -> String {

        let featureFlagsForModule: [Feature: Any] = definedFeatureFlags(
            forScheme: scheme!,
            forModule: module!
        )
        return featureFlagsForModule.value(for: key, default: "")
    }

    /// Get a Boolean value for a key or FALSE if it doesn't exist
    ///
    /// - Parameters:
    ///   - key: name for the feature
    ///   - inModule: module to which the feature belongs to
    /// - Returns: the value for your feature if there is one registered or an false
    public func value(
        for key: String,
        onScheme: FeatureManager.BuildScheme? = FeatureManager.BuildScheme(
            rawValue: Configuration.App.appDisplayName
        ),
        inModule: FeatureManager.Modules? = Modules.mainApp) -> Bool {

        let featureFlagsForScheme: [Feature: Any] = featureFlags.value(
            for: onScheme!.rawValue,
            default: [:]
        )

        let featureFlagsForModule: [Feature: Any] = featureFlagsForScheme.value(
            for: inModule!.rawValue,
            default: [:]
        )
        return featureFlagsForModule.value(for: key, default: false)
    }
}

private extension Dictionary where Key == String {
    func value<V>(for key: Key,
                  default defaultExpression: @autoclosure () -> V) -> V {
        (self[key] as? V) ?? defaultExpression()
    }
}
