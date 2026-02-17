//
//  Pager.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 16/02/2026.
//

import Foundation

// Can be used for both Videos and Images
actor Pager<Item: Identifiable & Sendable> {

    typealias PageResponse = (items: [Item], hasMore: Bool)
    typealias PageRequest = @Sendable (_ page: Int, _ limitPerPage: Int) async throws -> PageResponse

    private let limitPerPage: Int
    private var lastFetchedPage = 0

    private(set) var items: [Item] = []

    init(limitPerPage: Int = 10) {
        self.limitPerPage = limitPerPage
    }

    func fetchNextPage(request: PageRequest) async rethrows -> PagerResult {
        var page = lastFetchedPage
        page += 1

        let response = try await request(page, limitPerPage)

        let filteredPhotos = removeDuplicates(in: response.items)
        lastFetchedPage = page

        guard !filteredPhotos.isEmpty else {
            guard response.hasMore else {
                return PagerResult(hasNextPage: false)
            }
            return try await fetchNextPage(request: request)
        }

        items.append(contentsOf: filteredPhotos)
        return PagerResult(hasNextPage: response.hasMore)
    }

    private func removeDuplicates(in otherItems: [Item]) -> [Item] {
        // Map ids once
        let itemIDs = items.map(\.id)
        // Ensure uniqueness accross pages
        return otherItems.filter {
            !itemIDs.contains($0.id)
        }
    }

}

struct PagerResult {
    let hasNextPage: Bool
}
