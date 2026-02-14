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

        let response = PhotoListResponse(photos: [photo, photo], hasNextPage: true)
        await repository.update(response: response)

        // Fetch 1st page
        await viewModel.fetchNextPage()

        await #expect(repository.lastRequestedPage == 1)
        #expect(viewModel.photos.count == 2)

        // Fetch 2nd page
        await viewModel.fetchNextPage()

        await #expect(repository.lastRequestedPage == 2)
        #expect(viewModel.photos.count == 4)
    }

}
