//
//  APIManager.swift
//
//  Copyright © Jon Olivet. All rights reserved.
//

import Foundation

public protocol APIManagerProtocol {
    /// Configuración para proyectos ionix
    /// - Parameters:
    ///   - URLBase: url base del backend
    ///   - ionixServer: contratos de backend payload
    func configure(_ URLBase: String, ionixServer: Bool)

    /// Confuguración para proyectos externos a ionix
    /// - Parameter URLBase: url base del backend
    func configure(_ URLBase: String)

    /// Añade un nuevo header
    /// - Parameters:
    ///   - key: string
    ///   - value: string
    func setHeader(key: String, value: String)

    /// Elimina un header por la Key
    /// - Parameter key: string
    func removeHeader(key: String)

    /// GET
    /// - Parameters:
    ///   - uri: endpoint
    ///   - completion:  payload o error del servicio
    func get<T:Codable>(uri:String, completion: @escaping (Result<T,APIManagerError>) -> ())

    /// DELETE
    /// - Parameters:
    ///   - uri: endpoint
    ///   - completion: payload o error del servicio
    func delete<T:Codable>(uri:String, completion: @escaping (Result<T,APIManagerError>) -> ())

    /// POST
    /// - Parameters:
    ///   - uri: endpoint
    ///   - params: parametros del body
    ///   - completion: payload o error del servicio
    func post<T:Codable>(uri:String, params: [String: Any], completion: @escaping (Result<T,APIManagerError>) -> ())

    /// PUT
    /// - Parameters:
    ///   - uri: endpoint
    ///   - params: parametros del body
    ///   - completion: ayload o error de servicio
    func put<T:Codable>(uri:String, params: [String: Any], completion: @escaping (Result<T,APIManagerError>) -> ())
}

public class APIManager: APIManagerProtocol {
    public static let shared: APIManagerProtocol = APIManager()
    static var headers: [String: String] = [:]
    var BASE = ""
    let defaultSession = URLSession(configuration: .default)

    public func configure(_ URLBase: String, ionixServer: Bool) {
        self.BASE = URLBase
    }
    public func configure(_ URLBase: String) {
        self.BASE = URLBase
    }
    public func setHeader(key: String, value: String) {
        APIManager.headers[key] = value
    }

    func getHeaders() -> [String: String] {
        return APIManager.headers
    }

    public func removeHeader(key: String) {
        APIManager.headers.removeValue(forKey: key)
    }
}
