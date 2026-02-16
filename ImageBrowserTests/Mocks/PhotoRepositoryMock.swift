//
//  PhotoRepositoryMock.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation
@testable import ImageBrowser

actor PhotoRepositoryMock: PhotoRepositoryConvertible {

    var photos: [Photo] = []

    var hasNextPage = true

    enum Error: Swift.Error {
        case noResponse
    }

    private(set) var response: PhotoListResponse?

    private(set) var lastRequestedPage = 0

    func fetchNextPage() async throws -> PhotoRepository.FetchPageResult {
        guard hasNextPage else {
            return .init(hasNextPage: false)
        }

        lastRequestedPage += 1
        return .init(hasNextPage: true)
    }

}

// MARK: - Updates

extension PhotoRepositoryMock {

    func update(photos: [Photo]) {
        self.photos = photos
    }

    func update(hasNextPage: Bool) {
        self.hasNextPage = hasNextPage
    }

}
