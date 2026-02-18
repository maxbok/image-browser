//
//  Publisher+Utils.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 18/02/2026.
//

import Foundation
import Combine

public func change<Value: Sendable>(of publisher: Published<Value>.Publisher,
                                    after closure: @escaping @Sendable () async throws -> Void) async throws -> Value {
    var cancellable: AnyCancellable?

    let value = try await withCheckedThrowingContinuation { continuation in
        cancellable = publisher
            .dropFirst()
            .sink { value in
                Task {
                    continuation.resume(returning: value)
                }
            }

        Task {
            try await closure()
        }
    }

    cancellable?.cancel()
    return value
}
