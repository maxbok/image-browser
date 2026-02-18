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

    @Test(arguments: [
        PhotoRepository.RequestType.curated,
        .query("nature")
    ])
    func `Should return photos`(requestType: PhotoRepository.RequestType) async throws {
        await session.update(fixtureName: "Photos")

        let pager = await repository.pager(for: requestType)

        await #expect(pager.items.isEmpty)

        let result = try await pager.loadMore()
        #expect(result.hasNextPage)

        let photos = await pager.items
        #expect(photos.count == 3)

        let photo = try #require(photos.first)

        #expect(photo.id == 33563161)
        #expect(photo.photographer == "Natalie Goodwin")
        #expect(photo.description == "A trendy succulent in a red pot atop plant-themed books, perfect for interior design inspiration.")
        #expect(photo.averageHexColor == "#B0A390")
        #expect(photo.source.tiny.absoluteString == "https://images.pexels.com/photos/33563161/pexels-photo-33563161.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280")
        #expect(photo.source.large.absoluteString == "https://images.pexels.com/photos/33563161/pexels-photo-33563161.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940")
    }

    @Test
    func `Should cache curated pager`() async throws {
        await session.update(fixtureName: "Photos")

        let pager1 = await repository.pager(for: .curated)

        await #expect(pager1.items.isEmpty)
        _ = try await pager1.loadMore()

        await #expect(pager1.items.count == 3)

        let pager2 = await repository.pager(for: .curated)
        await #expect(pager2.items.count == 3)
    }

}
