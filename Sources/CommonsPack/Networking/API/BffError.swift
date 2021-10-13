//
//  BffError.swift
//  Alamofire
//
//  Copyright © Jon Olivet. All rights reserved.
//

import Foundation

public struct BffError: Codable, Equatable {
    public let title: String
    public let body: String
    public let code: Int
    public var data: Data?

    public init(title: String, body: String, code: Int, data: Data?) {
        self.title = title
        self.body = body
        self.code = code
        self.data = data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
            self.body = try container.decode(String.self, forKey: .body)
            self.code = try container.decode(Int.self, forKey: .code)
            self.data = try container.decodeIfPresent(Data.self, forKey: .data)
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "The given data was not valid JSON.",
                    underlyingError: error
                )
            )
        }
    }

    public static func == (lhs: BffError, rhs: BffError) -> Bool {
        lhs.title == rhs.title &&
            lhs.body == rhs.body &&
            lhs.code == rhs.code &&
            lhs.data == rhs.data
    }
}
