//
//  TextValidation.swift
//  BasicCommons
//
//

import Foundation

public protocol TextValidationProtocol {
    var regExFindMatchString: String { get }
    var validationMessage: String { get }
}

public extension TextValidationProtocol {

    var regExMatchingString: String {
        get {
            return regExFindMatchString + "$"
        }
    }
    
    func validateString(str: String) -> Bool {
        // 3 ways to validate
        // 1
        guard let regex = try? NSRegularExpression(pattern: regExMatchingString, options: []) else {
            return false
        }
        let range = NSRange(str.startIndex..., in: str)
        return regex.firstMatch(in: str, options: [], range: range) != nil
        
        // 2
//        let stringTest = NSPredicate(format: "SELF MATCHES %@", regExMatchingString)
//        return stringTest.evaluate(with: str)
        
        // 3
//        if let _ = str.range(of: regExMatchingString, options: .regularExpression) {
//            return true
//        } else {
//            return false
//        }
    }
    
    func getMatchingString(str: String) -> String? {
        if let newMatch = str.range(of: regExFindMatchString, options: .regularExpression) {
            return String(str[newMatch])
        } else {
            return nil
        }
    }
}

public class NumericValidation: TextValidationProtocol {
    public init(){}
    
    public var regExFindMatchString: String = "^[0-9]{0,6}"
    
    public var validationMessage: String = "You haven't entered a valid number.\nCome on now."
}
