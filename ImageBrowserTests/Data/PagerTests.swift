//
//  PagerTests.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 17/02/2026.
//

import Testing
@testable import ImageBrowser

struct PagerTests {

    struct Item: Identifiable {
        let id: Int
    }

    enum Error: Swift.Error {
        case unexpectedPage(Int)
    }

    let store = PagerRequestStore<Item>()

    @Test
    func `Should fetch next page and increment page index`() async throws {
        let pager = buildPager()
        await #expect(pager.items.isEmpty)

        // 1st page
        await store.update { page, limitPerPage in
            #expect(page == 1)
            #expect(limitPerPage == 10)
            return (items: [Item(id: 1)], hasNextPage: true)
        }

        let result1 = try await pager.loadMore()

        await #expect(pager.items.map(\.id) == [1])
        #expect(result1.hasNextPage)

        // 2nd page
        await store.update { page, limitPerPage in
            #expect(page == 2)
            #expect(limitPerPage == 10)
            return (items: [Item(id: 2)], hasNextPage: true)
        }

        let result2 = try await pager.loadMore()

        await #expect(pager.items.map(\.id) == [1, 2])
        #expect(result2.hasNextPage)
    }

    @Test(arguments: [
        ([1], [1, 2]),
        ([2, 3], [1, 2, 3]),
        ([3], [1, 2, 3])
    ])
    func `Should ensure uniqueness accross pages`(additionalItemIDs: [Int], expectedIDs: [Int]) async throws {
        let pager = buildPager()

        // 1st page
        await store.update { page, limitPerPage in
            (items: [Item(id: 1), Item(id: 2)], hasNextPage: true)
        }
        _ = try await pager.loadMore()

        await #expect(pager.items.map(\.id) == [1, 2])

        // 2nd page
        await store.update { page, limitPerPage in
            (items: additionalItemIDs.map(Item.init(id:)), hasNextPage: false)
        }
        _ = try await pager.loadMore()

        await #expect(pager.items.map(\.id) == expectedIDs)
    }

    @Test
    func `Should automatically fetch next page when fetched page only contains duplicates`() async throws {
        let pager = buildPager()

        // 1st page
        await store.update { page, limitPerPage in
            (items: [Item(id: 1)], hasNextPage: true)
        }
        _ = try await pager.loadMore()

        try await confirmation(expectedCount: 2) { confirmation in
            await store.update { page, _ in
                confirmation()

                return switch page {
                case 2:
                    // 2nd page with duplicates, will trigger another fetch
                    (items: [Item(id: 1)], hasNextPage: true)
                case 3:
                    // 3rd page with duplicates, all items already fetch
                    (items: [Item(id: 1)], hasNextPage: false)
                default:
                    throw Error.unexpectedPage(page)
                }
            }
            _ = try await pager.loadMore()
        }
    }

}

// MARK: - Utils

extension PagerTests {

    private func buildPager() -> Pager<Item> {
        Pager<Item> { page, limitPerPage in
            let request = try #require(await store.request)
            return try await request(page, limitPerPage)
        }
    }

}
