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
                ForEach(viewModel.photos) { photo in
                    PhotoGridItem(photo: photo)
                }
            }
            .padding(.horizontal)

            Color.clear
                .task {
                    await viewModel.fetchNextPage()
                }
        }
        .navigationTitle("grid.title")
    }

}

#Preview {
    NavigationStack {
        PhotoGridView()
    }
}
