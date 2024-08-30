//
//  City.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 8/30/24.
//

import Foundation

struct City: Codable {
    let name: String
    let longitude: Double
    let latitude: Double
    let weather: Weather
}
