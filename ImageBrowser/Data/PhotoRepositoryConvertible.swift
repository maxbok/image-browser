//
//  PhotoRepositoryConvertible.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

protocol PhotoRepositoryConvertible: Actor {

    func curatedPhotos(at page: Int, limit: Int) async throws -> PhotoListResponse

}
