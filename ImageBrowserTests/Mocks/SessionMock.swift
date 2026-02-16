//
//  SessionMock.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 14/02/2026.
//

import Foundation
@testable import ImageBrowser

actor SessionMock: SessionConvertible {

    private var fixtureName: String?
    private var fixtureNameOverrideBlock: (@Sendable (Request) -> String?)?

    func send<Object: Decodable & Sendable>(request: Request) async throws -> Object {
        guard let fixtureName = fixtureNameOverrideBlock?(request) ?? fixtureName else {
            throw Error.noFixtureName
        }
        guard let fixturePath = Bundle.test.url(forResource: fixtureName, withExtension: "json") else {
            throw Error.couldNotFindFixture
        }

        let data = try Data(contentsOf: fixturePath)
        return try JSONDecoder().decode(Object.self, from: data)
    }
}

extension SessionMock {

    enum Error: Swift.Error {
        case noFixtureName
        case couldNotFindFixture
    }

}

// MARK: - Updates

extension SessionMock {

    func update(fixtureName: String) {
        self.fixtureName = fixtureName
    }

    func fixtureNameOverride(block: (@escaping @Sendable (Request) -> String?)) {
        fixtureNameOverrideBlock = block
    }

}
