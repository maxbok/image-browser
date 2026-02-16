//
//  RevealTransition.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 15/02/2026.
//

import SwiftUI

extension View {

    func overlayTransition<Item, Content>(item: Binding<Item?>, content: (Item) -> Content)
    -> some View where Item: Identifiable, Content: View {
        ZStack {
            self

            if let itemValue = item.wrappedValue {
                content(itemValue)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: item.wrappedValue == nil)
    }

}
