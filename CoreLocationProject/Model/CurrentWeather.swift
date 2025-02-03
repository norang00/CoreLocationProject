//
//  CurrentWeather.swift
//  CoreLocationProject
//
//  Created by Kyuhee hong on 2/3/25.
//

import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Decodable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
}

// MARK: - Weather
struct Weather: Decodable {
    let main, description, icon: String
}

// MARK: - Main
struct Main: Decodable {
    let temp, tempMin, tempMax: Double // 현재 기온, 최저 기온, 최고 기온
    let humidity: Int // 습도
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

// MARK: - Wind
struct Wind: Decodable {
    let speed: Double // 풍속
}
