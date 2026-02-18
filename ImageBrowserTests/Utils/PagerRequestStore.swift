//
//  PagerRequestStore.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 18/02/2026.
//

import Foundation
@testable import ImageBrowser

actor PagerRequestStore<Item: Identifiable & Sendable> {

    var request: Pager<Item>.PageRequest?

    func update(request: @escaping Pager<Item>.PageRequest) {
        self.request = request
    }

}
