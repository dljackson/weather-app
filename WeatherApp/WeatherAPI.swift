//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 9/2/24.
//

import Foundation

struct WeatherAPI {
    static let host = "api.openweathermap.org"
    static let iconHost = "openweathermap.org"
    static let apiKey = "356428b0b136c160fd09959004278855"
    static let countryCode = "USA"
    static let iconImageType = "@2x.png"
    static let units = "imperial"
    
    enum Path: String {
        case geocode = "/geo/1.0/direct"
        case reverseGeocode = "/geo/1.0/reverse"
        case weather = "/data/3.0/onecall"
        case icon = "/img/wn/"
    }
    
    enum ParameterKey: String {
        case lat
        case lon
        case appid
        case units
        case q
        case limit
    }
}


