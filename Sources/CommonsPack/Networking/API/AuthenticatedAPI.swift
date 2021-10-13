//
//  AuthenticatedRequest.swift
//  BasicCommons
//
//  Copyright © Jon Olivet. All rights reserved.
//

import Alamofire
import UIKit

//swiftlint:disable file_length
//swiftlint:disable cyclomatic_complexity
//swiftlint:disable type_body_length
//swiftlint:disable function_parameter_count
//swiftlint:disable function_default_parameter_at_end    
public enum AdapterType: Equatable, Hashable {
    // NOTE: For each case implement the private method
    // `func adapt(_ urlRequest: URLRequest) -> URLRequest`
    // in the private extension at the end of this file
    case encrypted
    case timeout(seconds: Double)
    case withoutToken
    case deviceID
    case channel
    case domain(name: String)
    case connection
    case contentType(type: String)

    /// Only use for AvisoViaje
    case trackingId
    case originAddress // bff header only use in AvisoViaje
    case referenceOperation(operation: String)

    // For each case implement this method
    func adapt(_ urlRequest: URLRequest) -> URLRequest {
        var modifyUrlRequest = urlRequest
        switch self {
        case .timeout(let seconds):
            modifyUrlRequest.timeoutInterval = seconds
        case .withoutToken:
            var headers = modifyUrlRequest.allHTTPHeaderFields
            headers?.removeValue(forKey: AuthenticatedAPI.HTTPHeadersName.authorization.rawValue)
            modifyUrlRequest.allHTTPHeaderFields = headers
        case .deviceID:
            modifyUrlRequest.setValue(
                UIDevice.current.identifierForVendor?.uuidString ?? "",
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.deviceId.rawValue
            )
            modifyUrlRequest.setValue(
                UIDevice.current.identifierForVendor?.uuidString ?? "",
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.trackingId.rawValue
            )
        case .channel:
            modifyUrlRequest.setValue(
                Configuration.App.channelId,
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.channel.rawValue
            )
        case .domain(let domain):
            modifyUrlRequest.setValue(
                Configuration.App.channelId,
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.channel.rawValue
            )
            modifyUrlRequest.setValue(
                domain,
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.xDOMAINTRACKER.rawValue
            )
        case .encrypted:
            modifyUrlRequest.setValue(
                "on",
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.xMAINENCRYPT.rawValue
            )
        case .connection:
            modifyUrlRequest.setValue(
                "close",
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.connection.rawValue
            )
        case .trackingId:
            modifyUrlRequest.setValue(
                UIDevice.current.identifierForVendor?.uuidString ?? "",
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.trackingId.rawValue
            )
        case .originAddress:
            modifyUrlRequest.setValue(
                "111", // It should be deprecated in future version
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.originAddress.rawValue
            )
        case .referenceOperation(let operation):
            modifyUrlRequest.setValue(
                operation,
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.referenceOperation.rawValue
            )
        case .contentType(type: let type):
            modifyUrlRequest.setValue(
                type,
                forHTTPHeaderField: AuthenticatedAPI.HTTPHeadersName.contentType.rawValue
            )
        }
        return modifyUrlRequest
    }
}

/// AuthenticatedAPI API Class for Authentication
open class AuthenticatedAPI {

    /// This method will detect if the proxy is installed, and the port is 8080.
    ///
    /// - Returns: true if has a proxy on port 8080, false otherwise
    static func isProxyPort() -> Bool {
        if
            let proxyDictionary: NSDictionary = CFNetworkCopySystemProxySettings()?.takeUnretainedValue(),
            let port = proxyDictionary[kCFNetworkProxiesHTTPPort] as? Int,
            port == Configuration.App.MockServerProxy.httpsPort
        {
            debugPrint("=> app type and system proxy detected on port:", port)
            return true
        }
        return false
    }

    enum HTTPHeadersName: String {
        case applicationId = "Application-id"
        case authorization = "Authorization"
        case channel = "Channel"
        case referenceService = "Reference-Service"
        case referenceOperation = "Reference-Operation"
        case deviceId = "DeviceId"
        case xDOMAINTRACKER = "X-DOMAIN-TRACKER"
        case xMAINENCRYPT = "x-main-encrypt"
        case trackingId = "Tracking-Id"
        case connection = "Connection"
        case originAddress = "Origin-addr"
        case contentType = "Content-Type"
    }

    /// Init
    public init() {}

    ///public static func getHeadersWithoutToken
    public static func getHeadersWithoutToken() -> HTTPHeaders {
        let appId = "ios_v"+Configuration.App.version+"("+Configuration.App.bundleVersion+")"
        let headers: HTTPHeaders = [
            HTTPHeadersName.referenceService.rawValue: "app_ios",
            HTTPHeadersName.applicationId.rawValue: appId,
            HTTPHeadersName.channel.rawValue: "910",
            HTTPHeadersName.connection.rawValue: "close"
        ]
        return headers
    }

    ///public static func getHeaders
    public static func getHeaders() -> HTTPHeaders {
        var headers = getHeadersWithoutToken()
        if let token = Storage.retrieve(key: Configuration.App.APIToken) {
            headers[HTTPHeadersName.authorization.rawValue] = "Bearer \(token)"
        }
        return headers
    }

    ///public static func getHeadersWithDeviceId
    public static func getHeadersWithDeviceId() -> HTTPHeaders {
        var header = AuthenticatedAPI.getHeaders()
        header[HTTPHeadersName.deviceId.rawValue] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        header[HTTPHeadersName.trackingId.rawValue] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return header
    }

    ///public static func getHeadersWithChannel
    public static func getHeadersWithChannel() -> HTTPHeaders {
        var header = AuthenticatedAPI.getHeaders()
        header[HTTPHeadersName.channel.rawValue] = Configuration.App.channelId
        return header
    }

    ///public static func getHeadersWithDomain
    public static func getHeadersWithDomain(name: String) -> HTTPHeaders? {
        var headers = AuthenticatedAPI.getHeaders()
        headers[HTTPHeadersName.channel.rawValue] = Configuration.App.channelId
        headers[HTTPHeadersName.xDOMAINTRACKER.rawValue] = name
        return headers
    }

    /// This method will detect if the proxy and port are set then turn off the encryption,
    /// else will just return input value.
    /// Note: proxy is ignore completly ignore in production.
    ///
    /// - Parameter encrypted: this variable comes from the request, tells if request has encription enable.
    /// - Returns: Bool
    private func encryptionStatusWithMockServer(encrypted: Bool) -> Bool {
        let scheme = FeatureManager.BuildScheme(rawValue: Configuration.App.appDisplayName)
        guard !encrypted || scheme == .production else {
            return AuthenticatedAPI.isProxyPort() ? false : encrypted // apaga la encryptacion si es Proxy
        }
        return encrypted
    }

    // Helper methods

    private func getParameters(parameters: Parameters?, adapters: AdapterArray, encrypted: Bool) -> Parameters? {
        return parameters
    }

    /// Authenticated Request
    public func request(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = getHeaders(), //deprecated, it should use the default value and set using adapters
        validStatusCodes: [Int],
        encryptionIsNeeded: Bool = false, // deprecated
        authenticationHeaderIsNeeded: Bool = true,
        timeout: Double? = nil, //deprecated
        adapters: AdapterArray = [],
        onSuccess: @escaping ((DataResponse<Data>) -> Void),
        onFailure: @escaping (NTError, Int) -> Void) {

        let hasEncryption = encryptionStatusWithMockServer(encrypted: encryptionIsNeeded)
        let adaptersWithMockServer = adapters.eraseEncryptionIfNeeded()

        guard let requestURL = try? url.asURL() else {
            let error = NSError(
                domain: "com.MainApp.URLError",
                code: ErrorCode.invalidURL.rawValue,
                userInfo: nil
            )
            onFailure(
                NTError.invalidURL(error, nil),
                ErrorCode.invalidURL.rawValue
            )
            return
        }

        let backgroundTaskId = backgroundTaskIdFor(url: requestURL)

        let params = getParameters(parameters: parameters, adapters: adapters, encrypted: hasEncryption)

        let adaptersWithConnection = adaptersWithMockServer.addingConnectionHeaderIfNeeded()

        let encryptionIsNeeded = hasEncryption || adaptersWithConnection.adapters.contains(.encrypted)

        // deprecated
        let headersDict = headersWithEncrypt(
            headers: headers!,
            encryptionIsNeeded: encryptionIsNeeded
        )

        let sessionManager = APIManager.sessionManager()

        sessionManager.adapter = adaptersWithConnection

        sessionManager
            .request(url, method: method, parameters: params, encoding: encoding, headers: headersDict)
            .validate(statusCode: validStatusCodes)
            .responseData { data in

                if data.response == nil, let error = data.result.error {
                    let errorCode = (error as NSError).code

                    if errorCode == ErrorCode.networkConnectionWasLostShouldRetryRequest.rawValue {

                        self.request(
                            url: url,
                            method: method,
                            parameters: parameters,
                            encoding: encoding,
                            headers: headers,
                            validStatusCodes: validStatusCodes,
                            encryptionIsNeeded: encryptionIsNeeded,
                            authenticationHeaderIsNeeded: authenticationHeaderIsNeeded,
                            onSuccess: onSuccess,
                            onFailure: onFailure
                        )
                    } else if errorCode == ErrorCode.networkConnectionOffline.rawValue {
                        onFailure(
                            NTError.noInternetConection,
                            ErrorCode.noInternetConection.rawValue
                        )
                    } else {
                        onFailure(
                            NTError.unknown(
                                error,
                                data.data
                            ),
                            ErrorCode.unknown.rawValue
                        )
                    }

                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                    return
                }

                let statusCode = data.response?.statusCode ?? -1

                if data.result.isSuccess {
                    onSuccess(data)
                } else {
                    onFailure(
                        self.parseError(
                            data: data.data,
                            error: data.result.error
                        ),
                        statusCode
                    )
                }

                UIApplication.shared.endBackgroundTask(backgroundTaskId)
        }
    }

    /// requestGeneric alamofire function with decodable and generics Return
    public func requestGeneric<T: Decodable>(
        type: T.Type,
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = getHeaders(), //deprecated, it should use the default value and set using adapters
        validStatusCodes: [Int],
        keyPath: String? = nil,
        encryptionIsNeeded: Bool = false, // deprecated
        authenticationHeaderIsNeeded: Bool = true,
        timeout: Double? = nil, //deprecated
        adapters: AdapterArray = [],
        onSuccess: @escaping ((T?, DataResponse<T>, Int?) -> Void),
        onFailure: @escaping (NTError, Int) -> Void) {

        let hasEncryption = encryptionStatusWithMockServer(encrypted: encryptionIsNeeded)
        let adaptersWithMockServer = adapters.eraseEncryptionIfNeeded()

        guard let requestURL = try? url.asURL() else {
            let error = NSError(
                domain: "com.MainApp.URLError",
                code: ErrorCode.invalidURL.rawValue,
                userInfo: nil
            )
            onFailure(
                NTError.invalidURL(error, nil),
                ErrorCode.invalidURL.rawValue
            )
            return
        }
        let backgroundTaskId = backgroundTaskIdFor(url: requestURL)

        let params = getParameters(parameters: parameters, adapters: adapters, encrypted: hasEncryption)

        let adaptersWithConnection = adaptersWithMockServer.addingConnectionHeaderIfNeeded()

        let encryptionIsNeeded = hasEncryption || adaptersWithConnection.adapters.contains(.encrypted)

        // deprecated
        let headersDict = headersWithEncrypt(
            headers: headers!,
            encryptionIsNeeded: encryptionIsNeeded
        )

        let sessionManager = APIManager.sessionManager()

        sessionManager.adapter = adaptersWithConnection

        sessionManager
            .request(url, method: method, parameters: params, encoding: encoding, headers: headersDict)
            .validate(statusCode: validStatusCodes)
            .responseData { data in

                if data.response == nil, let error = data.result.error {
                    let errorCode = (error as NSError).code

                    if errorCode == ErrorCode.networkConnectionWasLostShouldRetryRequest.rawValue {

                        self.requestGeneric(
                            type: type,
                            url: url,
                            method: method,
                            parameters: parameters,
                            encoding: encoding,
                            headers: headers,
                            validStatusCodes: validStatusCodes,
                            keyPath: keyPath,
                            encryptionIsNeeded: encryptionIsNeeded,
                            authenticationHeaderIsNeeded: authenticationHeaderIsNeeded,
                            onSuccess: onSuccess,
                            onFailure: onFailure
                        )
                        return
                    } else if errorCode == ErrorCode.networkConnectionOffline.rawValue {
                        onFailure(
                            NTError.noInternetConection,
                            ErrorCode.noInternetConection.rawValue
                        )
                        UIApplication.shared.endBackgroundTask(backgroundTaskId)
                        return
                    }
                }

                let statusCode = data.response?.statusCode ?? -1

                // Handle 204 answer and return early
                if statusCode == HTTPStatusCodes.noContent.rawValue {

                    let error = NSError(domain: "", code: statusCode, userInfo: nil)
                    let newResponse: DataResponse<T> = DataResponse(
                        request: data.request,
                        response: data.response,
                        data: nil,
                        result: Result.failure(error)
                    )

                    onSuccess(nil, newResponse, statusCode)

                } else
                    if data.result.isSuccess {
                        let jsonDecoder = JSONDecoder()

                        guard
                            let dataResponse = data.data,
                            let returnData: T = try? jsonDecoder.decode(T.self, from: dataResponse)
                            else {
                                onFailure(self.parseError(data: data.data, error: data.result.error), statusCode)
                                UIApplication.shared.endBackgroundTask(backgroundTaskId)
                                return
                        }

                        let newResponse = DataResponse(
                            request: data.request,
                            response: data.response,
                            data: dataResponse,
                            result: .success(returnData)
                        )

                        onSuccess(returnData, newResponse, statusCode)
                    } else {
                        onFailure(self.parseError(data: data.data, error: data.result.error), statusCode)
                }

                UIApplication.shared.endBackgroundTask(backgroundTaskId)
        }
    }

    /// Cancel All Requests
    public func cancelAllRequest() {
        APIManager.sessionManager().session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }

    private func parseError(data: Data?, error: Error?) -> NTError {
        if let err = error {
            return NTError.from(err, content: data)
        }
        return NTError.unknown(.none, data)
    }

    private func headersWithEncrypt(headers: HTTPHeaders, encryptionIsNeeded: Bool) -> HTTPHeaders {
        var headersDict = headers
        if encryptionIsNeeded {
            headersDict[HTTPHeadersName.xMAINENCRYPT.rawValue] = "on"
        }
        return headersDict
    }

    private func backgroundTaskIdFor(url: URL) -> UIBackgroundTaskIdentifier {
        UIApplication.shared.beginBackgroundTask(withName: url.relativeString, expirationHandler: nil)
    }
}

public struct AdapterArray: RequestAdapter, ExpressibleByArrayLiteral {

    public typealias ArrayLiteralElement = AdapterType

    var adapters: Set<AdapterType>

    public init(arrayLiteral elements: AdapterType...) {
        adapters = []
        for element in elements {
            adapters.insert(element)
        }
    }

    public init(with adapters: [AdapterType]) {
        self.adapters = Set(adapters)
    }

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var modifyUrlRequest = urlRequest

        for adapter in adapters {
            modifyUrlRequest = adapter.adapt(modifyUrlRequest)
        }

        return modifyUrlRequest
    }

    func addingConnectionHeaderIfNeeded() -> AdapterArray {
        var array = self
        if !array.adapters.contains(.connection) {
            array.adapters.insert(.connection)
        }
        return array
    }

    func eraseEncryptionIfNeeded() -> AdapterArray {
        let scheme = FeatureManager.BuildScheme(rawValue: Configuration.App.appDisplayName)
        var array = self
        guard scheme == .production else {
            if AuthenticatedAPI.isProxyPort() {
                array.adapters.remove(.encrypted)
            }
            return array
        }
        return array
    }
}
