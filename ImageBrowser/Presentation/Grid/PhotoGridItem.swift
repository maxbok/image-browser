//
//  PhotoGridItem.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import SwiftUI

struct PhotoGridItem: View {

    let photo: Photo

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RemotePhoto(photo: photo, size: .tiny)
            text
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(.smallCornerRadius)
    }

    // MARK: - Text

    var text: some View {
        VStack(alignment: .leading) {
            Text(photo.photographer)
                .lineLimit(1)
                .font(.gridItemTitle)
            if !photo.description.isEmpty {
                Text(photo.description)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.gridItemDescription)
            }
        }
        .foregroundStyle(Color.gridText)
        .padding(.smallPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(textBackdrop)
    }

    var textBackdrop: some View {
        LinearGradient(
            colors: [.clear, .gridTextBackdrop],
            startPoint: .top,
            endPoint: .bottom
        )
    }

}

struct PhotoGridItem_Previews: PreviewProvider {

    static var previews: some View {
        PhotoGridItem(
            photo: .preview
        )
        .colorScheme(.light)
        .previewLayout(.fixed(width: 120, height: 120))

        PhotoGridItem(
            photo: .preview
        )
        .colorScheme(.dark)
        .previewLayout(.fixed(width: 120, height: 120))
    }

}
