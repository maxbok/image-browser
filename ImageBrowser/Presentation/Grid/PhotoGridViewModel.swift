//
//  PhotoGridViewModel.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation
import Combine

@MainActor
class PhotoGridViewModel: ObservableObject {

    @Published var query = ""

    @Published var selectedPhoto: Photo?

    @Published private(set) var isLoading = false
    @Published private(set) var photos: [Photo] = []

    private var hasMore = true

    private var currentPager: Pager<Photo>?
    private let repository: PhotoRepositoryConvertible

    private var cancellables: Set<AnyCancellable> = []

    init(repository: PhotoRepositoryConvertible = PhotoRepository()) {
        self.repository = repository

        setupBindings()
    }

    func onAppear() async {
        await setupPager(for: .curated)
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

    private func setupPager(for requestType: PhotoRepository.RequestType) async {
        currentPager = await repository.pager(for: requestType)
        await loadMore()
    }

}

// MARK: - Bindings

private extension PhotoGridViewModel {

    func setupBindings() {
        $query
            .removeDuplicates()
            .debounce(for: .textInputDebounce, scheduler: RunLoop.main)
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                Task {
                    await self?.setupPager(for: .query(query))
                }
            }
            .store(in: &cancellables)

        $query
            .dropFirst()
            .removeDuplicates()
            .filter(\.isEmpty)
            .sink { [weak self] _ in
                Task {
                    await self?.setupPager(for: .curated)
                }
            }
            .store(in: &cancellables)
    }

}
