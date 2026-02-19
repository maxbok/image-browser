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

        items.append(contentsOf: response.items)
        return PagerResult(hasNextPage: response.hasNextPage)
    }

}

struct PagerResult {
    let hasNextPage: Bool
}
