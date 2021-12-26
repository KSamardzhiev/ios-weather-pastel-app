//
//  ViewController.swift
//  WeatherPastel
//
//  Created by Kostadin Samardzhiev on 25.12.21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        weatherManager.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        textField.placeholder = "Please enter search term"
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //perform requesto to OpenWeather API
        weatherManager.fetchWeatherData(city: textField.text!)
        searchTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.temperatureLabel.text = weather.tempString
            self.conditionView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

