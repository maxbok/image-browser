//
//  CloseButton.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 15/02/2026.
//

import SwiftUI

struct CloseButton: View {

    let action: () -> Void

    var body: some View {
        if #available(iOS 26.0, *) {
            button
                .buttonBorderShape(.circle)
                .buttonStyle(.glass)
        } else {
            button
        }
    }

    var button: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 22))
                .foregroundStyle(Color.primary)
                .padding(.smallPadding)
        }
    }

}

#Preview {
    CloseButton {}
}
