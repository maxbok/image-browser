//
//  Request.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation

enum Request {

    case curatedImages(page: Int, limit: Int)

}

// MARK: - Error

extension Request {

    enum Error: Swift.Error {
        case couldNotCreateURLRequest
    }

}

// MARK: - URLRequest

extension Request {

    func urlRequest(with apiKey: String?) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            throw Error.couldNotCreateURLRequest
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        return request
    }

}

private extension Request {

    var host: String {
        "api.pexels.com"
    }

    var path: String {
        switch self {
        case .curatedImages: "/v1/curated"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case let .curatedImages(page, limit):
            [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(limit)")
            ]
        }
    }

}
