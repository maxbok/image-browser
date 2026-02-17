//
//  PhotoRepository.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

actor PhotoRepository: PhotoRepositoryConvertible {

    var photos: [Photo] {
        get async {
            await curatedPager.items
        }
    }

    private let curatedPager = Pager<Photo>()

    private let session: SessionConvertible

    init(session: SessionConvertible = Session()) {
        self.session = session
    }

    func fetchNextPage() async throws -> PagerResult {
        try await curatedPager.fetchNextPage { page, limitPerPage in
            let request: Request = .curatedImages(page: page, limit: limitPerPage)
            return try await execute(request: request)
        }
    }

    private func execute(request: Request) async throws -> Pager<Photo>.PageResponse {
        let response: PhotoListResponse = try await session.send(request: request)
        return (items: response.photos, hasMore: response.hasNextPage)
    }

}
