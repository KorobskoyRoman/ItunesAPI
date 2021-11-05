//
//  AlbumModel.swift
//  ItunesAPI
//
//  Created by Roman Korobskoy on 05.11.2021.
//

import Foundation

struct AlbumModel: Decodable, Equatable {
    let results: [Album]
}

struct Album: Decodable, Equatable {
    let artistName: String
    let collectionName: String
    let artworkUrl100: String? //Only returned when artwork is available
    let trackCount: Int
    let releaseDate: String
    let collectionId: Int
}
