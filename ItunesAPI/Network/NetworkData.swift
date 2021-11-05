//
//  NetworkData.swift
//  ItunesAPI
//
//  Created by Roman Korobskoy on 05.11.2021.
//

import Foundation

class NetworkData {
    
    static let shared = NetworkData()
    
    private init() {
    }
    
    func fetchAlbum(urlString: String, responce: @escaping(AlbumModel?, Error?) -> Void) {
        
        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do { //декодируем данные в модель
                    let albums = try JSONDecoder().decode(AlbumModel.self, from: data) //декодируем JSON
                    responce(albums, nil)
                } catch let jsonError{
                    print("failed decode JSON \(jsonError)")
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                responce(nil, error) //передаем nil т.к. модель не получить
            }
        }
    }
    
    func fetchSongs(urlString: String, responce: @escaping(SongsModel?, Error?) -> Void) {
        
        NetworkRequest.shared.requestData(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do { //декодируем данные в модель
                    let albums = try JSONDecoder().decode(SongsModel.self, from: data) //декодируем JSON
                    responce(albums, nil)
                } catch let jsonError{
                    print("failed decode JSON \(jsonError)")
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                responce(nil, error) //передаем nil т.к. модель не получить
            }
        }
    }
}
