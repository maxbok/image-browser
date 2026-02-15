//
//  Photo+Utils.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 15/02/2026.
//

import Foundation

extension Photo {

    var aspectRatio: CGFloat {
        CGFloat(width) / CGFloat(height)
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
        width: 3783,
        height: 5675,
        source: Photo.Source(
            tiny: URL(string: "https://images.pexels.com/photos/34408249/pexels-photo-34408249.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280")!,
            large: URL(string: "https://images.pexels.com/photos/34408249/pexels-photo-34408249.jpeg?auto=compress&cs=tinysrgb&h=650&w=940")!
        )
    )

}
#endif

