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
    let source: Source

    private enum CodingKeys: String, CodingKey {
        case id
        case photographer
        case description = "alt"
        case averageHexColor = "avg_color"
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

    }

}

#if DEBUG
// MARK: - Preview

extension Photo {

    static let preview = Photo(
        id: 1,
        photographer: "Michael Fischer",
        description: "Charming wooden cabins by a tranquil lake in Schladming, Austria, amidst stunning autumn alpine backdrop.",
        averageHexColor: "#5D5433",
        source: Photo.Source(
            tiny: URL(string: "https://images.pexels.com/photos/34408249/pexels-photo-34408249.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280")!,
            large: URL(string: "https://images.pexels.com/photos/34408249/pexels-photo-34408249.jpeg?auto=compress&cs=tinysrgb&h=650&w=940")!
        )
    )

}
#endif
