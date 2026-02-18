//
//  Photo+Mock.swift
//  ImageBrowserTests
//
//  Created by Maxime Bokobza on 18/02/2026.
//

@testable import ImageBrowser

extension Photo {

    static func mock(id: Int) -> Photo {
        Photo(
            id: id,
            photographer: "",
            description: "",
            averageHexColor: "",
            width: 100,
            height: 200,
            source: Photo.Source(
                tiny: .tinyPhoto,
                large: .largePhoto
            )
        )
    }

}
