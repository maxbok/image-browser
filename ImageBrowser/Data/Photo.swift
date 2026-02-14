//
//  Photo.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation

struct Photo: Identifiable, Decodable {

    let id: Int
    let photographer: String
    let description: String
    let averageHexColor: String
    let source: Source

    private enum CodingKeys: String, CodingKey {
        case id
        case photographer
        case description = "alt"
        case averageHexColor = "avg_color"
        case source = "src"
    }

}

// MARK: - Source

extension Photo {

    struct Source: Decodable {

        let tiny: URL
        let large: URL

    }

}
