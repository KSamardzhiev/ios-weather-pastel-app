//
//  WeatherManager.swift
//  WeatherPastel
//
//  Created by Kostadin Samardzhiev on 26.12.21.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let dataUrl = "https://api.openweathermap.org/data/2.5/weather?appid=827afa6967ec12baf070f638a7febeb3&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherData(city: String) {
        performRequest(with: "\(dataUrl)&q=\(city)")
    }
    
    func performRequest(with url: String) {
        if let requestUrl = URL(string: url) {
            let urlSession = URLSession(configuration: .default)
            let dataTask = urlSession.dataTask(with: requestUrl) { data, request, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weatherModel = parseJson(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weatherModel)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            
            let weatherModel = WeatherModel(conditionId: id, city: city, temp: temp)
            return weatherModel
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
