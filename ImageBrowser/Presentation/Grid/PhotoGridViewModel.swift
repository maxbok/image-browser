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

    private var hasMore = true

    private var currentPager: Pager<Photo>?
    private let repository: PhotoRepositoryConvertible

    init(repository: PhotoRepositoryConvertible = PhotoRepository()) {
        self.repository = repository
    }

    func onAppear() async {
        currentPager = await repository.pager(for: .curated)
        await loadMore()
    }

    func loadMore() async {
        guard let currentPager,
              !isLoading,
              hasMore
        else { return }

        isLoading = true
        defer {
            isLoading = false
        }

        do {
            let result = try await currentPager.loadMore()
            hasMore = result.hasNextPage
            photos = await currentPager.items
        } catch {
            // TODO: Handle errors
        }
    }

}
