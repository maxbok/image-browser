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

    @Test func `Should return photos`() async throws {
        await session.update(fixtureName: "Photos")

        await #expect(repository.photos.isEmpty)

        let result = try await repository.fetchNextPage()
        #expect(result.hasNextPage)

        let photos = await repository.photos

        #expect(photos.count == 3)

        let photo = try #require(photos.first)

        #expect(photo.id == 33563161)
        #expect(photo.photographer == "Natalie Goodwin")
        #expect(photo.description == "A trendy succulent in a red pot atop plant-themed books, perfect for interior design inspiration.")
        #expect(photo.averageHexColor == "#B0A390")
        #expect(photo.source.tiny.absoluteString == "https://images.pexels.com/photos/33563161/pexels-photo-33563161.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280")
        #expect(photo.source.large.absoluteString == "https://images.pexels.com/photos/33563161/pexels-photo-33563161.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940")
    }

}
