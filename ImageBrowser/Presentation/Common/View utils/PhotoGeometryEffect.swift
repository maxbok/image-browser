//
//  PhotoGeometryEffect.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 15/02/2026.
//

import SwiftUI

extension View {

    func matchedGeometryEffect(photo: Photo,
                               element: PhotoGeometryEffectElement,
                               in namespace: Namespace.ID,
                               isSource: Bool = true)
    -> some View {
        matchedGeometryEffect(
            id: "\(element.rawValue)_\(photo.id)",
            in: namespace,
            isSource: isSource
        )
    }

}

enum PhotoGeometryEffectElement: String {

    case content
    case photographer
    case description

}
