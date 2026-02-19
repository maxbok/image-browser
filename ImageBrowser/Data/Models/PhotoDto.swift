//
//  PhotoDto.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 19/02/2026.
//

import Foundation

struct PhotoDto: Decodable {

    let photographer: String
    let description: String
    let averageHexColor: String
    let width: Int
    let height: Int
    let source: Source

    private enum CodingKeys: String, CodingKey {
        case photographer
        case description = "alt"
        case averageHexColor = "avg_color"
        case width
        case height
        case source = "src"
    }

}

// MARK: - Source

extension PhotoDto {

    struct Source: Decodable {

        let tiny: URL
        let large: URL

        private enum CodingKeys: String, CodingKey {
            case tiny
            case large = "large2x"
        }

    }

}
