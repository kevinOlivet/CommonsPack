//
//  APIResponse.swift
//
//

import Foundation

public struct APIResponse<T:Decodable>: Decodable {
    let code: String
    let description: String?
    let payload: T?
}
