//
//  PhotoGridViewModelTests.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Testing
import Foundation
import Combine
@testable import ImageBrowser

@MainActor
struct PhotoGridViewModelTests {

    let repository = PhotoRepositoryMock()
    let viewModel: PhotoGridViewModel

    init() {
        viewModel = PhotoGridViewModel(repository: repository)
    }

    @Test
    func `Should load next page when requested`() async throws {
        #expect(viewModel.photos.isEmpty)

        await repository.update(photos: [.mock(id: 1), .mock(id: 2)])

        // Fetch 1st page
        await viewModel.onAppear()

        await #expect(repository.lastRequestedPage == 1)
        #expect(viewModel.photos.count == 2)

        await repository.update(photos: [.mock(id: 3)])

        // Fetch 2nd page
        await viewModel.loadMore()

        await #expect(repository.lastRequestedPage == 2)
        #expect(viewModel.photos.count == 3)
    }

    @Test
    func `Do not request next page when at the end of the list`() async throws {
        #expect(viewModel.photos.isEmpty)

        await repository.update(photos: [.mock(id: 1)])
        await repository.update(hasNextPage: false)

        // Fetch 1st page
        await viewModel.onAppear()

        await #expect(repository.lastRequestedPage == 1)
        #expect(viewModel.photos.count == 1)

        // No 2nd page to fetch
        await viewModel.loadMore()

        await #expect(repository.lastRequestedPage == 1)
        #expect(viewModel.photos.count == 1)
    }

    @Test
    func `Should update photos when searching`() async throws {
        await repository.update(photos: [.mock(id: 1), .mock(id: 2)])

        // Fetch curated 1st page
        await viewModel.onAppear()

        #expect(viewModel.photos.map(\.id) == [1, 2])

        // Search
        await repository.update(photos: [.mock(id: 3)])

        let naturePhotos = try await change(of: viewModel.$photos) { @MainActor in
            viewModel.query = "Nature"
        }

        #expect(naturePhotos.map(\.id) == [3])

        // Back to curated
        await repository.update(photos: [.mock(id: 4), .mock(id: 5)])

        let curatedPhotos = try await change(of: viewModel.$photos) { @MainActor in
            viewModel.query = ""
        }

        #expect(curatedPhotos.map(\.id) == [4, 5])
    }

}
