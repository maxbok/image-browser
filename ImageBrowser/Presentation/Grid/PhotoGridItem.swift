//
//  PhotoGridItem.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import SwiftUI

struct PhotoGridItem: View {

    let photo: Photo
    let namespace: Namespace.ID
    let isSource: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            content
        }
        .buttonStyle(ScaleButtonStyle())
    }

    // MARK: - Content

    private var content: some View {
        ZStack(alignment: .bottomLeading) {
            RemotePhoto(photo: photo, size: .tiny)
                .ignoreIntrinsicSize()
                .matchedGeometryEffect(
                    photo: photo,
                    element: .content,
                    in: namespace,
                    isSource: isSource
                )

            text
        }
        .aspectRatio(1, contentMode: .fit)
        .clipped()
        .cornerRadius(.smallCornerRadius)
    }

    // MARK: - Text

    private var text: some View {
        VStack(alignment: .leading) {
            Text(photo.photographer)
                .lineLimit(1)
                .font(.gridItemTitle)
                .matchedGeometryEffect(
                    photo: photo,
                    element: .photographer,
                    in: namespace,
                    isSource: isSource
                )
            if !photo.description.isEmpty {
                Text(photo.description)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.gridItemDescription)
                    .matchedGeometryEffect(
                        photo: photo,
                        element: .description,
                        in: namespace,
                        isSource: isSource
                    )
            }
        }
        .foregroundStyle(Color.gridText)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, .smallPadding)
        .padding(.bottom, .smallPadding)
        .padding(.top, .mediumPadding) // Improves text readability with a higher backdrop
        .background(textBackdrop)
    }

    private var textBackdrop: some View {
        LinearGradient(
            colors: [.clear, .gridTextBackdrop],
            startPoint: .top,
            endPoint: .bottom
        )
    }

}

private struct ScaleButtonStyle: ButtonStyle {

    private let scaledValue: CGFloat = 0.95
    private let animation: Animation = .easeInOut(duration: 0.15)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledValue : 1)
            .animation(animation, value: configuration.isPressed)
    }

}

struct PhotoGridItem_Previews: PreviewProvider {

    static var previews: some View {
        PhotoGridItem(photo: .preview, namespace: Namespace().wrappedValue, isSource: true) {}
            .colorScheme(.light)
            .previewLayout(.fixed(width: 120, height: 120))

        PhotoGridItem(photo: .preview, namespace: Namespace().wrappedValue, isSource: true) {}
            .colorScheme(.dark)
            .previewLayout(.fixed(width: 120, height: 120))
    }

}
