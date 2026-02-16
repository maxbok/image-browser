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

// MARK: - Orientation specific padding

enum ViewOrientation {

    case landscape

}

extension View {

    func padding(_ orientation: ViewOrientation, _ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> some View {
        modifier(PaddingViewModifier(orientation: orientation, edges: edges, length: length))
    }

}

private struct PaddingViewModifier: ViewModifier {

    let orientation: ViewOrientation
    let edges: Edge.Set
    let length: CGFloat?

    @Environment(\.verticalSizeClass) private var verticalSizeClass

    func body(content: Content) -> some View {
        switch (verticalSizeClass, orientation) {
        case (.compact, .landscape):
            content
                .padding(edges, length)
        default:
            content
        }
    }

}
