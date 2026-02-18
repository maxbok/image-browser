//
//  PhotoRepositoryMock.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation
@testable import ImageBrowser

actor PhotoRepositoryMock: PhotoRepositoryConvertible {

    private var photos: [Photo] = []
    private var hasNextPage = true

    enum Error: Swift.Error {
        case deallocated
    }

    private(set) var lastRequestedPage = 0

    func pager(for requestType: PhotoRepository.RequestType) -> Pager<Photo> {
        Pager<Photo> { [weak self] page, _ in
            guard let self else {
                throw Error.deallocated
            }
            return await mockedRequest(page: page)
        }
    }

    private func mockedRequest(page: Int) -> Pager<Photo>.PageResponse {
        lastRequestedPage = page
        return (items: photos, hasNextPage: hasNextPage)
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
