//
//  PhotoRepositoryTests.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Testing
import Foundation
@testable import ImageBrowser

struct PhotoRepositoryTests {

    let session = SessionMock()
    let repository: PhotoRepository

    init() {
        repository = PhotoRepository(session: session)
    }

    @Test func `Should return photos for a given page`() async throws {
        await session.update(fixtureName: "Photos")

        let response = try await repository.curatedPhotos(at: 1, limit: 10)
        let photos = response.photos

        #expect(photos.count == 3)

        #expect(photos[0].id == 33563161)
        #expect(photos[0].photographer == "Natalie Goodwin")
        #expect(photos[0].description == "A trendy succulent in a red pot atop plant-themed books, perfect for interior design inspiration.")
        #expect(photos[0].averageHexColor == "#B0A390")
        #expect(photos[0].source.tiny.absoluteString == "https://images.pexels.com/photos/33563161/pexels-photo-33563161.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280")
        #expect(photos[0].source.large.absoluteString == "https://images.pexels.com/photos/33563161/pexels-photo-33563161.jpeg?auto=compress&cs=tinysrgb&h=650&w=940")
    }

}
