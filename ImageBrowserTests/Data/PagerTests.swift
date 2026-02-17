//
//  PagerTests.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 17/02/2026.
//

import Testing
@testable import ImageBrowser

struct PagerTests {

    let pager = Pager<PagerItem>()

    enum Error: Swift.Error {
        case unexpectedPage
    }

    @Test func `Should fetch next page and increment page index`() async throws {
        await #expect(pager.items.isEmpty)

        let result1 = await pager.fetchNextPage { page, limitPerPage in
            #expect(page == 1)
            #expect(limitPerPage == 10)

            return (items: [PagerItem(id: 1)], hasMore: true)
        }

        await #expect(pager.items.map(\.id) == [1])
        #expect(result1.hasNextPage)

        let result2 = await pager.fetchNextPage { page, limitPerPage in
            #expect(page == 2)
            #expect(limitPerPage == 10)

            return (items: [PagerItem(id: 2)], hasMore: true)
        }

        await #expect(pager.items.map(\.id) == [1, 2])
        #expect(result2.hasNextPage)
    }

    @Test(arguments: [
        ([1], [1, 2]),
        ([2, 3], [1, 2, 3]),
        ([3], [1, 2, 3])
    ])
    func `Should ensure uniqueness accross pages`(additionalItemIDs: [Int], expectedIDs: [Int]) async throws {
        _ = await pager.fetchNextPage { _, _ in
            (items: [PagerItem(id: 1), PagerItem(id: 2)], hasMore: true)
        }
        await #expect(pager.items.map(\.id) == [1, 2])

        _ = await pager.fetchNextPage { _, _ in
            (items: additionalItemIDs.map(PagerItem.init(id:)), hasMore: false)
        }
        await #expect(pager.items.map(\.id) == expectedIDs)
    }

    @Test func `Should automatically fetch next page when fetched page only contains duplicates`() async throws {
        _ = await pager.fetchNextPage { page, _ in
            // First page
            (items: [PagerItem(id: 1)], hasMore: true)
        }

        try await confirmation(expectedCount: 2) { confirmation in
            _ = try await pager.fetchNextPage { page, _ in
                confirmation()

                return switch page {
                case 2:
                    // Second page with duplicates, will trigger another fetch
                    (items: [PagerItem(id: 1)], hasMore: true)
                case 3:
                    // Third page with duplicates, all items already fetch
                    (items: [PagerItem(id: 1)], hasMore: false)
                default:
                    throw Error.unexpectedPage
                }
            }
        }
    }

}

struct PagerItem: Identifiable {

    let id: Int

}
