//
//  PhotoRepository.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

actor PhotoRepository: PhotoRepositoryConvertible {

    private let session: SessionConvertible

    private var cachedPagers: [RequestType: Pager<Photo>] = [:]

    init(session: SessionConvertible = Session()) {
        self.session = session
    }

    func pager(for requestType: RequestType) -> Pager<Photo> {
        guard let pager = cachedPagers[requestType] else {
            let pager = buildPager(for: requestType)
            cache(pager: pager, for: requestType)
            return pager
        }

        return pager
    }

}

extension PhotoRepository {

    enum RequestType: Hashable {
        case curated
    }

    enum Error: Swift.Error {
        case deallocated
    }

}

// MARK: - Utils

private extension PhotoRepository {

    func buildPager(for requestType: RequestType) -> Pager<Photo> {
        Pager<Photo> { [weak self] page, limitPerPage in
            guard let self else {
                throw Error.deallocated
            }

            let request = await request(for: requestType, page: page, limitPerPage: limitPerPage)
            return try await execute(request: request)
        }
    }

    func request(for requestType: RequestType, page: Int, limitPerPage: Int) -> Request {
        switch requestType {
        case .curated:
            .curatedImages(page: page, limit: limitPerPage)
        }
    }

    func execute(request: Request) async throws -> Pager<Photo>.PageResponse {
        let response: PhotoListResponse = try await session.send(request: request)
        return (items: response.photos, hasNextPage: response.hasNextPage)
    }

    func cache(pager: Pager<Photo>, for requestType: RequestType) {
        // Only cache curated pager for now
        guard case .curated = requestType else {
            return
        }

        cachedPagers[requestType] = pager
    }

}
