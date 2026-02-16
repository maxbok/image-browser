//
//  PhotoRepository.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

actor PhotoRepository: PhotoRepositoryConvertible {

    struct FetchPageResult {
        let hasNextPage: Bool
    }

    private(set) var photos: [Photo] = []

    private let limitPerPage = 10
    private var lastFetchedPage = 0

    private let session: SessionConvertible

    init(session: SessionConvertible = Session()) {
        self.session = session
    }

    func fetchNextPage() async throws -> FetchPageResult {
        var page = lastFetchedPage
        page += 1

        let request: Request = .curatedImages(page: page, limit: limitPerPage)
        let response: PhotoListResponse = try await session.send(request: request)

        let filteredPhotos = removeDuplicates(in: response.photos)
        lastFetchedPage = page

        guard !filteredPhotos.isEmpty else {
            guard response.hasNextPage else {
                return FetchPageResult(hasNextPage: false)
            }
            return try await fetchNextPage()
        }

        photos.append(contentsOf: filteredPhotos)

        return FetchPageResult(hasNextPage: response.hasNextPage)
    }

    private func removeDuplicates(in otherPhotos: [Photo]) -> [Photo] {
        // Map ids once
        let photoIDs = photos.map(\.id)
        // Ensure uniqueness accross pages
        return otherPhotos.filter {
            !photoIDs.contains($0.id)
        }
    }

}
