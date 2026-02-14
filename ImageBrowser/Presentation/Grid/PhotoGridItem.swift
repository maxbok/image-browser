//
//  PhotoGridItem.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import SwiftUI
import NVMColor

struct PhotoGridItem: View {

    let photo: Photo

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // TODO: Display actual photo
            Color(hex: photo.averageHexColor)

            text
        }
        .cornerRadius(.smallCornerRadius)
        .aspectRatio(1, contentMode: .fit)
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
        PhotoGridItem(
            photo: photo
        )
        .colorScheme(.light)
        .previewLayout(.fixed(width: 120, height: 120))

        PhotoGridItem(
            photo: photo
        )
        .colorScheme(.dark)
        .previewLayout(.fixed(width: 120, height: 120))
    }

}
