//
//  PhotoRepositoryConvertible.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

protocol PhotoRepositoryConvertible: Actor {

    func pager(for requestType: PhotoRepository.RequestType) -> Pager<Photo>

}
