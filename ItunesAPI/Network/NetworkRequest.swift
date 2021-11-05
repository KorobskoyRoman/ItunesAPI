//
//  NetworkRequest.swift
//  ItunesAPI
//
//  Created by Roman Korobskoy on 05.11.2021.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    
    private init() {}
        
    func requestData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return } //получаем ссылку
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error = error { //в случае ошибки
                    completion(.failure(error)) //передаем в completion ошибку
                    return
                }
                guard let data = data else { return } //проверяем данные
                completion(.success(data))
            }
        }
        .resume() //выполняем запрос
    }
}
