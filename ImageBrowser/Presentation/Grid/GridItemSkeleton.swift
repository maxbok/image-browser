//
//  GridItemSkeleton.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 16/02/2026.
//

import SwiftUI

struct GridItemSkeleton: View {

    var body: some View {
        Skeleton(mode: .opaque)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(.smallCornerRadius)
    }

}

#Preview {
    GridItemSkeleton()
}
