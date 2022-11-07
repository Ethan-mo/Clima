//
//  WeatherData.swift
//  Clima
//
//  Created by 모상현 on 2022/11/07.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
 
}
struct Main: Codable{
    let temp: Double
}
struct Weather: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}
