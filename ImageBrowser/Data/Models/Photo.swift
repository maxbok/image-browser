//
//  Photo.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation

struct Photo: Identifiable {

    let id: UUID // Ensures uniqueness
    let photographer: String
    let description: String
    let metadata: Metadata
    let source: Source

}

// MARK: - Metadata

extension Photo {

    struct Metadata {

        let averageHexColor: String
        let width: Int
        let height: Int

    }

}

// MARK: - Source

extension Photo {

    struct Source {

        let tiny: URL
        let large: URL

    }

}

// MARK: - Equatable

extension Photo: Equatable {

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }

}

// MARK: - Init from dto

extension Photo {

    init(from dto: PhotoDto) {
        id = UUID()
        photographer = dto.photographer
        description = dto.description
        metadata = Metadata(
            averageHexColor: dto.averageHexColor,
            width: dto.width,
            height: dto.height
        )
        source = Source(tiny: dto.source.tiny, large: dto.source.large)
    }

}
