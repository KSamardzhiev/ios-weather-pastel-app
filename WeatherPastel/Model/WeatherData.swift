//
//  WeatherData.swift
//  WeatherPastel
//
//  Created by Kostadin Samardzhiev on 26.12.21.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let cod: Int
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather:Decodable {
    let id: Int
    let main: String
    let description: String
}
