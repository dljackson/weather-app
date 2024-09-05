//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 9/5/24.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?
}

extension Endpoint {
    static func weather(for lat: Double, lon: Double) -> Endpoint {
        Endpoint(path: WeatherAPI.Path.weather.rawValue,
                 queryItems: [URLQueryItem(key: .lat, value: String(lat)),
                              URLQueryItem(key: .lon, value: String(lon)),
                              URLQueryItem(key: .appid, value: WeatherAPI.apiKey),
                              URLQueryItem(key: .units, value: WeatherAPI.units)])
    }
    
    static func search(with city: String, and state: String) -> Endpoint {
        Endpoint(path: WeatherAPI.Path.geocode.rawValue,
                 queryItems: [URLQueryItem(key: .q, value: "\(city), \(state), \(WeatherAPI.countryCode)"),
                              URLQueryItem(key: .limit, value: "3"),
                              URLQueryItem(key: .appid, value: WeatherAPI.apiKey)])
    }
    
    static func reverseGeocode(lat: Double, lon: Double) -> Endpoint {
        Endpoint(path: WeatherAPI.Path.reverseGeocode.rawValue,
                 queryItems: [URLQueryItem(key: .lat, value: String(lat)),
                              URLQueryItem(key: .lon, value: String(lon)),
                              URLQueryItem(key: .appid, value: WeatherAPI.apiKey)])
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = WeatherAPI.host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    var iconUrl: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = WeatherAPI.iconHost
        components.path = WeatherAPI.Path.icon.rawValue + path + WeatherAPI.iconImageType
        return components.url
    }
    func url(for icon: String) -> URL? {
        URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}

/// Extending URLQueryItem to be able to use enum keys instead of strings for name
extension URLQueryItem {
    init(key: WeatherAPI.ParameterKey, value: String?) {
        self.init(name: key.rawValue, value: value)
    }
}
