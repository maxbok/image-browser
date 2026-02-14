//
//  SessionConvertible.swift
//  ImageBrowser
//
//  Created by Maxime Bokobza on 14/02/2026.
//

protocol SessionConvertible: Actor {

    func send<Object: Decodable & Sendable>(request: Request) async throws -> Object

}
