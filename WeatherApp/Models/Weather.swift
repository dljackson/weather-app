//
//  Weather.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 8/30/24.
//

import Foundation

struct Weather: Decodable {
    let current: Forecast
    let hourly: [Forecast]
    let daily: [Forecast]
}
