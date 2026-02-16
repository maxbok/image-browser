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

    @Published var selectedPhoto: Photo?

    @Published var query = ""

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
            let result = try await repository.fetchNextPage()
            hasNextPage = result.hasNextPage
            photos = await repository.photos
        } catch {
            // TODO: Handle errors
        }
    }

}
