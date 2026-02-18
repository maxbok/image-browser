//
//  PhotoListResponse.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation

struct PhotoListResponse {

    let photos: [Photo]
    let hasNextPage: Bool

}

extension PhotoListResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case photos
        case nextPage = "next_page"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        photos = try container.decode([Photo].self, forKey: .photos)
        let nextPage = try container.decodeIfPresent(String.self, forKey: .nextPage)
        hasNextPage = nextPage != nil
    }

}
