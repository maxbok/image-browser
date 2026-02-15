//
//  PhotoGridView.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import SwiftUI

struct PhotoGridView: View {

    @StateObject var viewModel = PhotoGridViewModel()

    @Namespace private var namespace

    var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: .smallPadding),
            count: 3
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            title

            grid

            if viewModel.isLoading {
                // TODO: Improve this
                Text("Loading...")
            }
        }
        .padding(.horizontal)
        .overlayTransition(item: $viewModel.selectedPhoto) { photo in
            PhotoDetailView(
                photo: photo,
                namespace: namespace,
                dismiss: {
                    withAnimation(.easeInOut) {
                        viewModel.selectedPhoto = nil
                    }
                }
            )
        }
        .task {
            await viewModel.fetchNextPage()
        }
    }

    var title: some View {
        Text("grid.title")
            .font(.gridTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
    }

    // MARK: - Grid

    var grid: some View {
        LazyVGrid(columns: columns) {
            ForEach(Array(viewModel.photos.enumerated()), id: \.offset) { _, photo in
                item(with: photo)
            }
        }
    }

    func item(with photo: Photo) -> some View {
        PhotoGridItem(photo: photo, namespace: namespace) {
            withAnimation(.easeInOut) {
                viewModel.selectedPhoto = photo
            }
        }
        .task {
            guard photo == viewModel.photos.last else { return }

            await viewModel.fetchNextPage()
        }
    }

}

#Preview {
    PhotoGridView()
}
