//
//  Skeleton.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 18/02/2026.
//

import SwiftUI

struct Skeleton: View {

    enum Mode {
        case translucent
        case opaque
    }

    let mode: Mode

    @State private var animate = false

    var body: some View {
        gradient
            .onAppear {
                withAnimation(.skeletonLoop) {
                    animate = true
                }
            }
    }

}

// MARK: - Gradient

extension Skeleton {

    var gradient: LinearGradient {
        LinearGradient(
            colors: colors,
            startPoint: UnitPoint(x: animate ? 1 : -2, y: 0),
            endPoint: UnitPoint(x: animate ? 3 : 0, y: 0)
        )
    }

    private var color1: Color {
        switch mode {
        case .translucent:
            .clear
        case .opaque:
            .skeleton1
        }
    }

    private var color2: Color {
        let opacity: Double = switch mode {
        case .translucent:
            0.2
        case .opaque:
            1
        }

        return Color.skeleton2.opacity(opacity)
    }

    private var colors: [Color] {
        [color1, color2, color1]
    }

}

// MARK: - Animation

private extension Animation {

    static var skeletonLoop: Animation {
        linear(duration: duration)
            .delay(delay)
            .repeatForever(autoreverses: false)
            .delay(startingDelay - delay)
    }

    private static let duration: TimeInterval = 1.2
    private static let startingDelay: TimeInterval = 0.1
    private static let delay: TimeInterval = 0.5

}

#Preview {
    Skeleton(mode: .translucent)
}
