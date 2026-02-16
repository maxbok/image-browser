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
        ScrollView {
            title
            grid
        }
        .scrollIndicators(.hidden)
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

    private var title: some View {
        Text("grid.title")
            .font(.gridTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical)
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
