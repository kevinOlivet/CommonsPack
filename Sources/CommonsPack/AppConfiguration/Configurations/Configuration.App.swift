//
//  Configuration.App.swift
//  AppConfiguration
//
//  Copyright © Jon Olivet. All rights reserved.
//

//swiftlint:disable missing_docs
//swiftlint:disable line_length

/// Methods to access General App configuration
public extension Configuration.App {

    /// static let APIToken
    static let APIToken = "apiToken"

    /// Get the scheme to connect to the API
    static var appDisplayName: String {
        guard let appDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String else {
            return FeatureManager.BuildScheme.debug.rawValue
        }
        return appDisplayName
    }

    /// Get the scheme to connect to the API
    static var schemeName: String {
        var schemeName = Bundle.main.infoDictionary!["Scheme"] as? String
        // Legacy
        if schemeName == nil {
            schemeName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String
        }
        return schemeName ?? "main-dev"
    }

    /// Get App Version
    static var version: String {
        guard let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "1.0.0"
        }
        return version
    }

    /// Get App Bundle Version
    static var bundleVersion: String {
        guard let bundleVersion: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return "1"
        }
        return bundleVersion
    }

    /// Get the General App Timeout for internet requests
    static var timeout: Double {
        guard let timeout: Double = Configuration.configurationValueForKeyAndSubKey(
            key: "App",
            subKey: "timeout"
            ) as? Double else {
            return 0
        }
        return timeout
    }

    /// Should use Stubs
    static var stubs: Bool {
        guard let useStubs: Bool = Configuration.configurationValueForKeyAndSubKey(
            key: "App",
            subKey: "stubs"
            ) as? Bool else {
            return false
        }

        return useStubs
    }

    /// Get the configured Locale for the App
    static var locale: String {
        Configuration.configurationForKeyAndSubKey(key: "App", subKey: "locale")
    }

    /// Get the configured Timezone for the App
    static var timezone: String {
        Configuration.configurationForKeyAndSubKey(key: "App", subKey: "timezone")
    }

    /// Get the channel configured for the App
    static var channelId: String {
         Configuration.configurationForKeyAndSubKey(key: "App", subKey: "CHANNEL_ID")
    }

    enum Network {
        public static let ReferenceService = "app_ios"
        public static let AplicationIdPrefix = "ios_v"
        public static let ConnectionHeaderValue = "close"
        public static let Bearer = "Bearer"
        public static let EncryptHeaderValue = "on"
    }

    enum MockServerProxy {
        public static let httpsPort: Int = 8080
    }

    enum Urls {
        public enum API {
            public enum Login {
                public static let BorrarDispositivoKey = "{device_key}"
            }
        }
    }

    enum RootViewControllersType: Int {
        case navigation = 0

        public enum NavigationControllersType: Int {
            case login = 0
            case mainTabBar = 1
        }
    }
}
