//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        
    }
    
    
    @IBAction func nowLocationTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}
// MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // 이제 textField에서 작업이 끝난것으로 보인다면..
        if searchTextField.text != ""{
            // 키보드를 내린다(끝 처리를 해준다.)
            return true
        }else{
            textField.placeholder = "도시를 입력해주세요."
            // 키보드를 내리지 않는다.(끝 처리를 해주지 않는다.)
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text == ""
    }
}

// MARK: - CustomDelegate
extension WeatherViewController: WeatherManagerDelegate{
    //My API Key: 2a190fbf7dce2c5d1ef8c1d7fe8906b1
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
        }
        
        print(weather.conditionId)
    }
    func didFailWithError(error: Error) {
         print(error)
    }
}
// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
