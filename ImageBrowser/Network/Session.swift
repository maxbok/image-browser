//
//  Session.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation

actor Session: SessionConvertible {

    enum Error: Swift.Error {
        case unknownResponseType
        case requestFailed(code: Int)
    }

    private let urlSession: URLSession = .shared
    private let jsonDecoder = JSONDecoder()

    private lazy var apiKey: String? = {
        guard let apiKeyFile = Bundle.main.url(forResource: "API_KEY", withExtension: nil) else {
            return nil
        }
        return try? String(contentsOf: apiKeyFile).trimmingCharacters(in: .whitespacesAndNewlines)
    }()

    func send<Object: Decodable & Sendable>(request: Request) async throws -> Object {
        let (data, response) = try await urlSession.data(for: request.urlRequest(with: apiKey))

        guard let response = response as? HTTPURLResponse else {
            throw Error.unknownResponseType
        }

        let code = response.statusCode
        guard (200 ..< 400).contains(code) else {
            throw Error.requestFailed(code: code)
        }

        return try jsonDecoder.decode(Object.self, from: data)
    }

}
