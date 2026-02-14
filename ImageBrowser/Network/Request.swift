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

    var urlRequest: URLRequest {
        get throws {
            var components = URLComponents()
            components.scheme = "https"
            components.host = host
            components.path = path
            components.queryItems = queryItems

            guard let url = components.url else {
                throw Error.couldNotCreateURLRequest
            }

            return URLRequest(url: url)
        }
    }

    private var host: String {
        "api.pexels.com"
    }

    private var path: String {
        switch self {
        case .curatedImages: "v1/curated"
        }
    }

    private var queryItems: [URLQueryItem] {
        switch self {
        case let .curatedImages(page, limit):
            [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(limit)")
            ]
        }
    }

}
