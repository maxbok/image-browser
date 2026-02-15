//
//  RemotePhoto.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 15/02/2026.
//

import SwiftUI
import NVMColor

struct RemotePhoto: View {

    enum Size {
        case tiny
    }

    let photo: Photo
    let size: Size

    var body: some View {
        AsyncImage(
            url: url,
            content: { image in
                Color.clear
                    .overlay {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
            },
            placeholder: {
                Color(hex: photo.averageHexColor)
            }
        )
    }

}

// MARK: - Utils

extension RemotePhoto {

    var url: URL {
        switch size {
        case .tiny: photo.source.tiny
        }
    }

}

struct RemotePhoto_Previews: PreviewProvider {

    static let photo = Photo(
        id: 1,
        photographer: "Michael Fischer",
        description: "Charming wooden cabins by a tranquil lake in Schladming, Austria, amidst stunning autumn alpine backdrop.",
        averageHexColor: "#5D5433",
        source: Photo.Source(
            tiny: URL(string: "https://images.pexels.com/photos/34408249/pexels-photo-34408249.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280")!,
            large: URL(string: "https://images.pexels.com/photos/34408249/pexels-photo-34408249.jpeg?auto=compress&cs=tinysrgb&h=650&w=940")!
        )
    )

    static var previews: some View {
        RemotePhoto(photo: photo, size: .tiny)
            .previewLayout(.fixed(width: 120, height: 200))
    }

}
