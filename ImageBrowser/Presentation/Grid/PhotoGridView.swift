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

    private let columnsCount = 3

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: .smallPadding),
            count: columnsCount
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                grid
            }
            .scrollIndicators(.hidden)
            .searchable(text: $viewModel.query, prompt: "search.prompt")
            .navigationTitle("grid.title")
        }
        .overlayTransition(item: $viewModel.selectedPhoto) { photo in
            PhotoDetailView(
                photo: photo,
                namespace: namespace,
                dismiss: {
                    viewModel.selectedPhoto = nil
                }
            )
        }
        .task {
            await viewModel.fetchNextPage()
        }
    }

    // MARK: - Grid

    private var grid: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.photos, id: \.id) { photo in
                item(with: photo)
            }

            if viewModel.isLoading {
                skeletonItems
            }
        }
        .padding(.horizontal)
    }

    private var skeletonItemsCount: Int {
        columnsCount - viewModel.photos.count % columnsCount
    }

    private var skeletonItems: some View {
        ForEach(0 ..< skeletonItemsCount, id: \.self) { _ in
            GridItemSkeleton()
        }
    }

    private func item(with photo: Photo) -> some View {
        PhotoGridItem(
            photo: photo,
            namespace: namespace,
            isSource: viewModel.selectedPhoto == nil
        ) {
            viewModel.selectedPhoto = photo
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
