//
//  NTError.swift
//  Alamofire
//
//  Copyright © Jon Olivet. All rights reserved.
//

import Alamofire
import Foundation

/// Describes a custom error code to be used on API failure responses
///
/// - invalidURL: invalid URL
/// - noInternetConection: The request failed due to internet conecction was no available
/// - requestTimeOut: The request failed due to it exceded the waiting time
/// - unknown: An unknown error
public enum ErrorCode: Int {
    case networkConnectionWasLostShouldRetryRequest     = -1005 // swiftlint:disable:this identifier_name
    case networkConnectionOffline                       = -1009
    case invalidURL                                     = -1010
    case noInternetConection                            = -1011
    case noTokenFound                                   = -1012
    case unknown                                        = -1
    case tooManyRequests                                = 429
}

/// Describes an networking layer error
///
/// - invalidURL: The url is invalid. It should be of type 'www.example.com'var/
/// - parameterEncoding: The parameters were unable to serialize in the request
/// - multipartEncoding: The multipart enconding failed
/// - responseValidation: The HTTP method returns an error. Valids code are From 200-399
/// - responseSerialization: The response object was unable to serialize
/// - noInternetConection: The request failed due to internet conecction was no available
/// - requestTimeOut: The request failed due to it exceded the waiting time
/// - unknown: An unknown error
public enum NTError: Error {
    case invalidURL(Error, Data?)
    case parameterEncoding(Error, Data?)
    case multipartEncoding(Error, Data?)
    case bff(Error?, BffError?)
    case bffRaw(Error?, Data?)
    case responseSerialization(Error, Data?)
    case noInternetConection
    case noTokenFound
    case cancelled
    case requestTimeOut
    case unknown(Error?, Data?)

    /// Transform an underlying request error into  `NTError`
    ///
    /// - Parameters:
    ///   - afError: An `Error` type. It can be an `AFError` NSError
    ///   - content: The content response body
    /// - Returns: An new instance of `NTError` describing the failure
    internal static func from(_ afError: Error, content: Data?) -> NTError {
        if afError is AFError {

            guard let anAFError: AFError = afError as? AFError else {
                return .unknown(afError, content)
            }
            switch anAFError {
            case .invalidURL:
                return .invalidURL(anAFError, content)
            case .parameterEncodingFailed:
                return .parameterEncoding(anAFError, content)
            case .multipartEncodingFailed:
                return .multipartEncoding(anAFError, content)
            case .responseSerializationFailed:
                return .responseSerialization(anAFError, content)
            case .responseValidationFailed:
                let jsonDecode: JSONDecoder = JSONDecoder()
                do {
                    var error: BffError? = try jsonDecode.decode(BffError.self, from: content ?? Data())
                    error?.data = content
                    return .bff(anAFError, error)
                } catch {
                    return .bffRaw(anAFError, content)
                }
            }
        } else {
            let nserror: NSError = afError as NSError
            if nserror.code == -1_009 {
                return .noInternetConection
            } else if nserror.code == -1_001 || nserror.code == -72_007 {
                return .requestTimeOut
            } else if nserror.code ==  -999 {
                return .cancelled
            } else {
                return .unknown(afError, content)
            }
        }
    }
}
