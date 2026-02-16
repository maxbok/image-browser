//
//  PhotoRepositoryConvertible.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

protocol PhotoRepositoryConvertible: Actor {

    var photos: [Photo] { get }

    func fetchNextPage() async throws -> PhotoRepository.FetchPageResult

}
