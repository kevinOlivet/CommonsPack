//
//  Configuration.Api.swift
//  BasicCommons
//
//  Copyright © Jon Olivet. All rights reserved.
//

import Foundation

/// String extension
public extension String {
    /// This computed property is black mamba magic, it will return your url path only, no scheme, no host.
    var path: String {
        self.replacingOccurrences(of: Configuration.Api.baseUrl, with: "")
    }
}

/// Methods to access General API configuration
public extension Configuration.Api {

    /// Returns the Host name for the API
    static var host: String {
        Configuration.configurationForKeyAndSubKey(key: "Api", subKey: "host")
    }

    /// Returns the Scheme for the API
    static var scheme: String {
        Configuration.configurationForKeyAndSubKey(key: "Api", subKey: "scheme")
    }

    /// Returns the Base URL for the API
    static var baseUrl: String {
        scheme + host
    }

    /// Returns the Base Path for the API
    static var basePath: String {
        Configuration.configurationForKeyAndSubKey(key: "Api", subKey: "basePath")
    }

    /// Get the General ApI Timeout for internet requests
    static var timeout: Double {
        guard let timeout: Double = Configuration.configurationValueForKeyAndSubKey(
            key: "Api",
            subKey: "timeout"
            ) as? Double else {
                return 0
        }
        return timeout
    }
}
