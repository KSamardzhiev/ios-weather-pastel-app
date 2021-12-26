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
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    var dataUrl: String { return "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey ?? "INVALID_KEY")&units=metric"
    }
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherData(city: String) {
        print(dataUrl)
        performRequest(with: "\(dataUrl)&q=\(city)")
    }
    
    func fetchWeatherDataByCoordinates(latitude: Double, longitude: Double) {
        performRequest(with: "\(dataUrl)&lat=\(latitude)&lon=\(longitude)")
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
