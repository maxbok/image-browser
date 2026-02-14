//
//  PhotoRepository.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

actor PhotoRepository: PhotoRepositoryConvertible {

    private let session: SessionConvertible

    init(session: SessionConvertible = Session()) {
        self.session = session
    }

    func curatedPhotos(at page: Int, limit: Int) async throws -> PhotoListResponse {
        try await session.send(request: .curatedImages(page: page, limit: limit))
    }

}
