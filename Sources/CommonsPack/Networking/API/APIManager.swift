//
//  APIManager.swift
//
//  Copyright © Jon Olivet. All rights reserved.
//

import Alamofire
import Foundation

/// APIManager public enum implementation
public enum APIManager {

    private static let pinnedSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        let timeout = Configuration.Api.timeout
        configuration.timeoutIntervalForResource = timeout
        configuration.timeoutIntervalForRequest = timeout

        return SessionManager(
            configuration: configuration
        )
    }()

    /// sessionManager public func implementation
    public static func sessionManager() -> SessionManager {
        self.pinnedSessionManager
    }
}
