//
//  Pager.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 16/02/2026.
//

import Foundation

// Can be used for both Videos and Images
actor Pager<Item: Identifiable & Sendable> {

    typealias PageResponse = (items: [Item], hasNextPage: Bool)
    typealias PageRequest = @Sendable (_ page: Int, _ limitPerPage: Int) async throws -> PageResponse

    private(set) var items: [Item] = []

    private let limitPerPage: Int
    private let request: PageRequest

    private var lastPageFetched = 0

    init(limitPerPage: Int = 10, request: @escaping PageRequest) {
        self.limitPerPage = limitPerPage
        self.request = request
    }

    func loadMore() async throws -> PagerResult {
        var page = lastPageFetched
        page += 1

        let response = try await request(page, limitPerPage)
        lastPageFetched = page

        let filteredPhotos = removeDuplicates(in: response.items)

        guard !filteredPhotos.isEmpty else {
            guard response.hasNextPage else {
                return PagerResult(hasNextPage: false)
            }
            return try await loadMore()
        }

        items.append(contentsOf: filteredPhotos)
        return PagerResult(hasNextPage: response.hasNextPage)
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
