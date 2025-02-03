//
//  OpenWeatherRequest.swift
//  CoreLocationProject
//
//  Created by Kyuhee hong on 2/3/25.
//

import Alamofire

enum OpenWeatherRequest {
    case currentWeather(lat: Double, lon: Double, appId: String)
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/weather"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
        case .currentWeather(let lat, let lon, let appId):
            return ["lat": lat, "lon": lon, "appId": appId]
        }
    }
    
    func getIconURL(_ id: String) -> String {
        return "https://openweathermap.org/img/wn/\(id)@2x.png"
    }
}
