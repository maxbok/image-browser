//
//  PhotoRepositoryMock.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation
@testable import ImageBrowser

actor PhotoRepositoryMock: PhotoRepositoryConvertible {

    enum Error: Swift.Error {
        case noResponse
    }

    private(set) var response: PhotoListResponse?

    private(set) var lastRequestedPage: Int?

    func curatedPhotos(at page: Int, limit: Int) async throws -> PhotoListResponse {
        lastRequestedPage = page

        guard let response else {
            throw Error.noResponse
        }
        return response
    }

}

extension PhotoRepositoryMock {

    func update(response: PhotoListResponse) {
        self.response = response
    }

}
