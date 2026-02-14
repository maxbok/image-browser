//
//  Photo.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation

struct Photo: Decodable {

    let photographer: String
    let description: String
    let source: Source

    private enum CodingKeys: String, CodingKey {
        case photographer
        case description = "alt"
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
