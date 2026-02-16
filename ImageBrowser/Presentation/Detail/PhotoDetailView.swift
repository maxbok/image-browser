//
//  PhotoDetailView.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 15/02/2026.
//

import SwiftUI
import NVMColor

struct PhotoDetailView: View {

    let photo: Photo
    let namespace: Namespace.ID
    let dismiss: () -> Void
    
    var body: some View {
            ZStack(alignment: .topTrailing) {
                ScrollView {
                    VStack(spacing: .mediumPadding) {
                        photoView
                        text
                    }
                    .padding(.top, .largePadding)
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)

                CloseButton(action: dismiss)
                    .padding(.horizontal)
                    .padding(.landscape, .top, .smallPadding)
            }
            .background {
                Color(hex: photo.averageHexColor)
                    .adjustForColorScheme()
                    .ignoresSafeArea()
            }
    }

    private var photoView: some View {
        RemotePhoto(photo: photo, size: .large)
            .aspectRatio(photo.aspectRatio, contentMode: .fit)
            .cornerRadius(.largeCornerRadius)
            .shadow(radius: .largeShadowRadius)
            .matchedGeometryEffect(
                photo: photo,
                element: .content,
                in: namespace
            )
    }

    private var text: some View {
        VStack(alignment: .leading) {
            Text("\(photo.photographer) 📸")
                .font(.detailTitle)
                .matchedGeometryEffect(
                    photo: photo,
                    element: .photographer,
                    in: namespace
                )

            Text(photo.description)
                .font(.detailDescription)
                .matchedGeometryEffect(
                    photo: photo,
                    element: .description,
                    in: namespace
                )
        }
        .foregroundStyle(Color.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}

#Preview {
    PhotoDetailView(
        photo: .preview,
        namespace: Namespace().wrappedValue
    ) {}
}
