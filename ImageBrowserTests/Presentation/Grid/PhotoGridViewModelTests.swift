//
//  PhotoGridViewModelTests.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Testing
import Foundation
@testable import ImageBrowser

@MainActor
struct PhotoGridViewModelTests {

    let photo = Photo(
        id: 1,
        photographer: "",
        description: "",
        averageHexColor: "",
        width: 100,
        height: 200,
        source: Photo.Source(
            tiny: .tinyPhoto,
            large: .largePhoto
        )
    )

    let repository = PhotoRepositoryMock()
    let viewModel: PhotoGridViewModel

    init() {
        viewModel = PhotoGridViewModel(repository: repository)
    }

    @Test func `Should load next page when requested`() async throws {
        #expect(viewModel.photos.isEmpty)

        await repository.update(photos: [photo, photo])

        // Fetch 1st page
        await viewModel.fetchNextPage()

        await #expect(repository.lastRequestedPage == 1)
        #expect(viewModel.photos.count == 2)

        await repository.update(photos: [photo, photo, photo])

        // Fetch 2nd page
        await viewModel.fetchNextPage()

        await #expect(repository.lastRequestedPage == 2)
        #expect(viewModel.photos.count == 3)
    }

    @Test func `Do not request next page when at the end of the list`() async throws {
        #expect(viewModel.photos.isEmpty)

        await repository.update(photos: [photo])

        // Fetch 1st page
        await viewModel.fetchNextPage()

        await #expect(repository.lastRequestedPage == 1)
        #expect(viewModel.photos.count == 1)

        await repository.update(hasNextPage: false)

        // No 2nd page to fetch
        await viewModel.fetchNextPage()

        await #expect(repository.lastRequestedPage == 1)
        #expect(viewModel.photos.count == 1)
    }

}
