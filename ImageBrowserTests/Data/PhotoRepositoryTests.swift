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
        await session.update(fixtureName: "Photos1")

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
        #expect(photo.source.large.absoluteString == "https://images.pexels.com/photos/33563161/pexels-photo-33563161.jpeg?auto=compress&cs=tinysrgb&h=650&w=940")
    }

    @Test func `Should ensure photos uniqueness accross pages`() async throws {
        await session.update(fixtureName: "Photos1")
        let result1 = try await repository.fetchNextPage()
        #expect(result1.hasNextPage)

        await #expect(repository.photos.map(\.photographer) == [
            "Natalie Goodwin",
            "Michael Fischer",
            "Frank Wesneck"
        ])

        await session.update(fixtureName: "Photos2")
        let result2 = try await repository.fetchNextPage()
        #expect(!result2.hasNextPage)

        await #expect(repository.photos.map(\.photographer) == [
            "Natalie Goodwin",
            "Michael Fischer",
            "Frank Wesneck",
            "Susan  Flores",
            "Eugenia Remark"
        ])
    }

    @Test func `Should automatically fetch next page when fetched page only contains duplicates`() async throws {
        await session.fixtureNameOverride { request in
            switch request {
            case .curatedImages(page: 1, _),
                 .curatedImages(page: 2, _):
                "Photos1"
            case .curatedImages(page: 3, _):
                "Photos2"
            default:
                nil
            }
        }

        await #expect(repository.photos.isEmpty)

        _ = try await repository.fetchNextPage()
        let photos1 = await repository.photos
        #expect(photos1.count == 3)

        _ = try await repository.fetchNextPage()
        let photos2 = await repository.photos
        #expect(photos2.count == 5)
    }

    @Test func `Should stop automatic next page fetch when there are no next page`() async throws {
        await session.fixtureNameOverride { request in
            switch request {
            case .curatedImages(page: 1, _),
                 .curatedImages(page: 2, _):
                "Photos1"
            case .curatedImages(page: 3, _):
                "Photos1WithoutNextPage"
            default:
                nil
            }
        }

        await #expect(repository.photos.isEmpty)

        _ = try await repository.fetchNextPage()
        let photos1 = await repository.photos
        #expect(photos1.count == 3)

        _ = try await repository.fetchNextPage()
        let photos2 = await repository.photos
        #expect(photos2.count == 3)
    }

}
