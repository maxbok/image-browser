//
//  Photo.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation

struct Photo: Identifiable, Equatable, Decodable {

    let id: Int
    let photographer: String
    let description: String
    let averageHexColor: String
    let width: Int
    let height: Int
    let source: Source

    private enum CodingKeys: String, CodingKey {
        case id
        case photographer
        case description = "alt"
        case averageHexColor = "avg_color"
        case width
        case height
        case source = "src"
    }

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }

}

// MARK: - Source

extension Photo {

    struct Source: Decodable {

        let tiny: URL
        let large: URL

        private enum CodingKeys: String, CodingKey {
            case tiny
            case large = "large2x"
        }

    }

}
