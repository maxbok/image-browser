//
//  GridItemSkeleton.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 16/02/2026.
//

import SwiftUI

struct GridItemSkeleton: View {

    @State private var animate = false

    private let gradientSize: CGFloat = 40

    private var colors: [Color] {
        [
            .skeleton1,
            .skeleton2,
            .skeleton1
        ]
    }

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: UnitPoint(x: animate ? 1 : -2, y: 0),
            endPoint: UnitPoint(x: animate ? 3 : 0, y: 0)
        )
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(.smallCornerRadius)
        .onAppear {
            withAnimation(.skeletonLoop) {
                animate = true
            }
        }
    }

}

private extension Animation {

    static var skeletonLoop: Animation {
        linear(duration: duration)
            .delay(delay)
            .repeatForever(autoreverses: false)
            .delay(startingDelay - delay)
    }

    private static let duration: TimeInterval = 0.8
    private static let startingDelay: TimeInterval = 0.1
    private static let delay: TimeInterval = 1.5

}

#Preview {
    GridItemSkeleton()
}
