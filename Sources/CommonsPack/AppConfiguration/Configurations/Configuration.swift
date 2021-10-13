//
//  Configuration.swift
//  BasicCommons
//
//  Copyright © Jon Olivet. All rights reserved.
//

import Foundation

/// This enum will hold all the apps config metadata. you can expand to be used on another domains.
public enum Configuration {
    /// Hold Application configuration
    public enum App {}
    /// Hold Google Analytics configuration
    public enum GoogleAnalytics {}
    /// Hold API configuration
    public enum Api {}
    /// Hold Microservices API configuration
    public enum ApiMs {}
    /// Hold Feature toggle configuration
    public enum FeatureToggle {}

    // MARK: - Method to handle Configuration
    //This extension adds methods for handling the Configuration.plist
    //Please dont add more methods below this line

    /// Get the value for a Key and SubKey as Any
    public static func configurationValueForKeyAndSubKey(key: String, subKey: String) -> Any {
        if let keyDictionary: [String: Any] = Configuration.baseConfigurationDictionary[key] as? [String: Any] {
            if let enviromentDictionary: Dictionary = keyDictionary[subKey] as? [String: Any] {
                return enviromentDictionary[Configuration.App.schemeName.lowercased()] as Any
            } else {
                return keyDictionary[subKey] as Any
            }
        }
        return ""
    }

    /// Get the value for a Key and SubKey as String using an optional base configuration dictionary
    public static func configurationValueForKeyAndSubKey(
        key: String,
        subKey: String,
        baseConfigurationDictionary: [String: Any] = Configuration.baseConfigurationDictionary) -> Any? {

        if let keyDictionary: [String: Any] = baseConfigurationDictionary[key] as? [String: Any] {
            if let enviromentDictionary: Dictionary = keyDictionary[subKey] as? [String: Any] {
                return enviromentDictionary[Configuration.App.schemeName.lowercased()] as Any
            } else {
                return keyDictionary[subKey] as Any
            }
        }

        return nil
    }

    /// Get the value for a Key and SubKey as String using an optional base configuration dictionary
    public static func configurationForKeyAndSubKey(
        key: String,
        subKey: String,
        baseConfigurationDictionary: [String: Any] = Configuration.baseConfigurationDictionary) -> String {

        let value: Any? = configurationValueForKeyAndSubKey(
            key: key,
            subKey: subKey,
            baseConfigurationDictionary: baseConfigurationDictionary
        )
        if let result: String = value as? String {
            return result
        }

        return ""
    }

    /// Get the value for a Key and SubKey as Bool using an optional base configuration dictionary
    public static func configurationForKeyAndSubKey(
        key: String,
        subKey: String,
        baseConfigurationDictionary: [String: Any] = Configuration.baseConfigurationDictionary) -> Bool {

        let value: Any? = configurationValueForKeyAndSubKey(
            key: key,
            subKey: subKey,
            baseConfigurationDictionary: baseConfigurationDictionary
        )
        if let result: Bool = value as? Bool {
            return result
        }

        return false
    }

    /// Access the base configuration directly
    public static var baseConfigurationDictionary: [String: Any] {
        let baseConfigurationsResoucePath: URL? = Bundle.main.url(
            forResource: "Configurations",
            withExtension: "plist"
        )

        let data: Data? = try? Data(contentsOf: baseConfigurationsResoucePath!)

        if let data: Data = data,
            let propertyList: Any = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ),
            let result: [String: Any] = propertyList as? [String: Any] {
            return result
        }

        return [:]
    }
}
