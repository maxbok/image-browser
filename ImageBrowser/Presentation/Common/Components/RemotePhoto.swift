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
        case large
    }

    let photo: Photo
    let size: Size

    var body: some View {
        AsyncImage(
            url: url,
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            },
            placeholder: {
                ZStack {
                    Color(hex: photo.metadata.averageHexColor)
                    Skeleton(mode: .translucent)
                }
            }
        )
    }

}

// MARK: - Utils

extension RemotePhoto {

    var url: URL {
        switch size {
        case .tiny: photo.source.tiny
        case .large: photo.source.large
        }
    }

}

struct RemotePhoto_Previews: PreviewProvider {

    static var previews: some View {
        RemotePhoto(photo: .preview, size: .tiny)
            .previewLayout(.fixed(width: 120, height: 120))
    }

}
