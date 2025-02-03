//
//  NetworkManager.swift
//  CoreLocationProject
//
//  Created by Kyuhee hong on 2/3/25.
//

import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    final func getCurrentWeather<T: Decodable>(_ api: OpenWeatherRequest,
                                               _ type: T.Type,
                                               completionHandler: @escaping (Result<T, AFError>) -> Void) {
        AF.request(api.baseURL, method: api.method, parameters: api.parameter)
            .validate(statusCode: 200..<400)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(.success(value))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
    
}
