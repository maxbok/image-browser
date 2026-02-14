//
//  PhotoGridView.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import SwiftUI

struct PhotoGridView: View {

    @StateObject var viewModel = PhotoGridViewModel()

    var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: .smallPadding),
            count: 3
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns) {
                ForEach(Array(viewModel.photos.enumerated()), id: \.offset) { _, photo in
                    PhotoGridItem(photo: photo)
                        .task {
                            guard photo == viewModel.photos.last else { return }

                            await viewModel.fetchNextPage()
                        }
                }
            }
            .padding(.horizontal)

            if viewModel.isLoading {
                // TODO: Improve this
                Text("Loading...")
            }
        }
        .navigationTitle("grid.title")
        .task {
            await viewModel.fetchNextPage()
        }
    }

}

#Preview {
    NavigationStack {
        PhotoGridView()
    }
}
