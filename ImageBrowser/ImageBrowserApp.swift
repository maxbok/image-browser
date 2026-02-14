//
//  ImageBrowserApp.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 13/02/2026.
//

import SwiftUI

@main
struct ImageBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PhotoGridView()
            }
        }
    }
}
