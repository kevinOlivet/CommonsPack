//
//  Storage.swift
//  BasicCommons
//
//  Copyright © Jon Olivet
//

import SwiftKeychainWrapper
//import SwiftyJSON
import UIKit

public class Storage: NSObject {

    @discardableResult
    public static func set(key: String, value: String) -> Bool {
        KeychainWrapper.standard.set(value, forKey: key)
    }

    @discardableResult
    public static func object(key: String, value: NSCoding) -> Bool {
        KeychainWrapper.standard.set(value, forKey: key)
    }

    public static func hasValue(key: String) -> Bool {
        KeychainWrapper.standard.hasValue(forKey: key)
    }

    public static func retrieve(key: String) -> String? {
        return KeychainWrapper.standard.string(forKey: key)
    }

    public static func retrieveObject(key: String) -> NSCoding? {
        KeychainWrapper.standard.object(forKey: key)
    }

    @discardableResult
    public static func remove(key: String) -> Bool {
        KeychainWrapper.standard.removeObject(forKey: key)
    }

    @discardableResult
    public static func removeAll() -> Bool {
        KeychainWrapper.standard.removeAllKeys()
    }

    public static func removeToken() {
        // ********************************************************************
        // IMPORTANT: only remove the token correctly not using "invalidTokens"
        // ********************************************************************

        if Storage.retrieve(key: Configuration.App.APIToken) != nil {
            remove(key: Configuration.App.APIToken)
        }
    }

    public static func cleanOnLogout() {
        Storage.removeToken()
    }
}
