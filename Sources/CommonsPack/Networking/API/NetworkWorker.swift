//
//  NetworkWorker.swift
//  BasicCommons
//
//  Copyright © Jon Olivet. All rights reserved.
//

import Alamofire
import Foundation

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]

/// A dictionary of headers to apply to a `URLRequest`.
public typealias HTTPHeaders = [String: String]

/// A successfull clousure type on request completion
public typealias SuccessCallBack = (Data?, Int) -> Void

/// A failure clousure type on request completion
public typealias ErrorCallBack = (NTError, Int) -> Void

/// The encoding type used to serialize request parameters
///
/// - queryURL: Encode parameters in the url
/// - httpBody: Encode parameter in the body request
public enum ParamEncoding {
    /// The ParamEncoding options
    case queryURL, httpBody
}

/// Types that conform to the `NetworkRequestable` protocol can provide a network comunication service with a web
/// server using the `HTTP` or `HTTPS` protocol
public protocol NetworkRequestable {

    /// An implementation for HTTP `POST` method
    ///
    /// - Parameters:
    ///   - url: The web service url
    ///   - params: The parameter attached to the url
    ///   - encoding: The pameters encoding, default is httpBody
    ///   - headers: The request headers
    ///   - success: A clousure to be executed when the method finishes successfully
    ///   - failure: A clousure to be executed when the method finishes unsuccessfully
    func POST( // swiftlint:disable:this function_parameter_count
        url: String,
        params: Parameters?,
        encoding: ParamEncoding?,
        headers: HTTPHeaders?,
        success: @escaping SuccessCallBack,
        failure: @escaping ErrorCallBack)

    /// An implementation for HTTP `EGT` method
    ///
    /// - Parameters:
    ///   - url: The web service url
    ///   - params: The parameter attached to the url
    ///   - encoding: The pameters encoding, default is queryURL
    ///   - headers: The request headers
    ///   - success: A clousure to be executed when the method finishes successfully
    ///   - failure: A clousure to be executed when the method finishes unsuccessfully
    func GET( // swiftlint:disable:this function_parameter_count
        url: String,
        params: Parameters?,
        encoding: ParamEncoding?,
        headers: HTTPHeaders?,
        success: @escaping SuccessCallBack,
        failure: @escaping ErrorCallBack)

    /// An implementation for HTTP `PUT` method
    ///
    /// - Parameters:
    ///   - url: The web service url
    ///   - params: The parameter attached to the url
    ///   - encoding: The pameters encoding, default is httpBody
    ///   - headers: The request headers
    ///   - success: A clousure to be executed when the method finishes successfully
    ///   - failure: A clousure to be executed when the method finishes unsuccessfully
    func PUT( // swiftlint:disable:this function_parameter_count
        url: String,
        params: Parameters?,
        encoding: ParamEncoding?,
        headers: HTTPHeaders?,
        success: @escaping SuccessCallBack,
        failure: @escaping ErrorCallBack)

    /// An implementation for HTTP `DELETE` method
    ///
    /// - Parameters:
    ///   - url: The web service url
    ///   - params: The parameter attached to the url
    ///   - encoding: The pameters encoding, default is httpBody
    ///   - headers: The request headers
    ///   - success: A clousure to be executed when the method finishes successfully
    ///   - failure: A clousure to be executed when the method finishes unsuccessfully
    func DELETE( // swiftlint:disable:this function_parameter_count
        url: String,
        params: Parameters?,
        encoding: ParamEncoding?,
        headers: HTTPHeaders?,
        success: @escaping SuccessCallBack,
        failure: @escaping ErrorCallBack)
}

final class NetworkWorker: AuthenticatedAPI, NetworkRequestable {

    func POST( // swiftlint:disable:this function_parameter_count
        url: String,
        params: Parameters?,
        encoding: ParamEncoding?,
        headers: HTTPHeaders?,
        success: @escaping SuccessCallBack,
        failure: @escaping ErrorCallBack) {
        self.request(
            url: url,
            method: .post,
            parameters: params,
            encoding: URLEncoding.default,
            headers: headers,
            validStatusCodes: Array(200..<399),
            onSuccess: { [weak self] response in
                self?.onComplete(response: response, success: success, failure: failure)
            },
            onFailure: { error, code in
                debugPrint(error.localizedDescription)
            }
        )
    }

    func GET( // swiftlint:disable:this function_parameter_count
        url: String,
        params: Parameters?,
        encoding: ParamEncoding?,
        headers: HTTPHeaders?,
        success: @escaping SuccessCallBack,
        failure: @escaping ErrorCallBack) {
        self.request(
            url: url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default,
            headers: headers,
            validStatusCodes: Array(200..<399),
            onSuccess: { [weak self] response in
                self?.onComplete(response: response, success: success, failure: failure)
            },
            onFailure: { error, code in
                debugPrint(error.localizedDescription)
            }
        )
    }

    func PUT( // swiftlint:disable:this function_parameter_count
        url: String,
        params: Parameters?,
        encoding: ParamEncoding?,
        headers: HTTPHeaders?,
        success: @escaping SuccessCallBack,
        failure: @escaping ErrorCallBack) {
        self.request(
            url: url,
            method: .put,
            parameters: params,
            encoding: URLEncoding.default,
            headers: headers,
            validStatusCodes: Array(200..<399),
            onSuccess: { [weak self] response in
                self?.onComplete(response: response, success: success, failure: failure)
            },
            onFailure: { error, code in
                debugPrint(error.localizedDescription)
            }
        )
    }

    func DELETE( // swiftlint:disable:this function_parameter_count
        url: String,
        params: Parameters?,
        encoding: ParamEncoding?,
        headers: HTTPHeaders?,
        success: @escaping SuccessCallBack,
        failure: @escaping ErrorCallBack) {

        self.request(
            url: url,
            method: .delete,
            parameters: params,
            encoding: URLEncoding.default,
            headers: headers,
            validStatusCodes: Array(200..<399),
            onSuccess: { [weak self] response in
                self?.onComplete(response: response, success: success, failure: failure)
            },
            onFailure: { error, code in
                debugPrint(error.localizedDescription)
            }
        )
    }

    func onComplete(response: DataResponse<Data>, success: SuccessCallBack, failure: ErrorCallBack) {
        let status = response.response?.statusCode
        if response.result.isSuccess {
            let payload = response.result.value
            success(payload, status ?? -1)
        } else {
            let payload = response.data
            if let error = response.result.error {
                let nte = NTError.from(error, content: payload)
                failure(nte, status ?? -1)
            } else {
                failure(NTError.unknown(.none, response.data), status ?? -1)
            }
        }
    }
}
