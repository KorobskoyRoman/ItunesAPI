//
//  SongsModel.swift
//  ItunesAPI
//
//  Created by Roman Korobskoy on 06.11.2021.
//

import Foundation

struct SongsModel: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    let trackName: String?
}
