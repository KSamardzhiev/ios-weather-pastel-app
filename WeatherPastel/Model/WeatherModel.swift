//
//  WeatherModel.swift
//  WeatherPastel
//
//  Created by Kostadin Samardzhiev on 26.12.21.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let city: String
    let temp: Double
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200..<300: return "cloud.bolt"
        case 300..<500: return "cloud.drizzle"
        case 500..<600: return "cloud.heavyrain"
        case 600..<700: return "snow"
        case 801..<805: return "cloud"
        default:
            return "sparkles"
        }
    }
}
