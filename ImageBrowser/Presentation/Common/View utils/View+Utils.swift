//
//  View+Utils.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 15/02/2026.
//

import SwiftUI

extension View {

    func ignoreIntrinsicSize() -> some View {
        Color.clear
            .overlay {
                self
            }
            .clipped()
    }

    func adjustForColorScheme() -> some View {
        ZStack {
            self
            Color(.systemBackground).opacity(0.2)
        }
    }

}
