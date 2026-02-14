//
//  PhotoListResponse.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation

struct PhotoListResponse: Decodable {

    let photos: [Photo]

    var hasNextPage: Bool {
        nextPage != nil
    }

    private var nextPage: URL?

    private enum CodingKeys: String, CodingKey {
        case photos
        case nextPage = "next_page"
    }

}
