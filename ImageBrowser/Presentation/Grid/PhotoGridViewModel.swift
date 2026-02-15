//
//  PhotoGridViewModel.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Combine

@MainActor
class PhotoGridViewModel: ObservableObject {

    @Published private(set) var isLoading = false
    @Published private(set) var photos: [Photo] = []

    private let limitPerPage = 10
    private var lastFetchedPage = 0
    private var hasNextPage = true

    private let repository: PhotoRepositoryConvertible

    init(repository: PhotoRepositoryConvertible = PhotoRepository()) {
        self.repository = repository
    }

    func fetchNextPage() async {
        guard !isLoading,
              hasNextPage
        else { return }

        isLoading = true
        defer {
            isLoading = false
        }

        do {
            var page = lastFetchedPage
            page += 1
            let response = try await repository.curatedPhotos(at: page, limit: limitPerPage)
            lastFetchedPage = page

            photos.append(contentsOf: response.photos)
            hasNextPage = response.hasNextPage
        } catch {
            // TODO: Handle errors
        }
    }

}
