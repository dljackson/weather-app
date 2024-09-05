//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 9/5/24.
//

import Foundation

struct Endpoint {
    
    let path: WeatherAPI.Path
    let queryItems: [URLQueryItem]
}

extension Endpoint {
//    static func icon(name: String) -> Endpoint {
//        Endpoint(path: "/img/wn/\(name)@2x.png", queryItems: [])
//    }
    
    static func weather(for lat: Double, lon: Double) -> Endpoint {
        Endpoint(path: .weather, queryItems: [URLQueryItem(key: .lat, value: String(lat)),
                                              URLQueryItem(key: .lon, value: String(lon)),
                                              URLQueryItem(key: .appid, value: WeatherAPI.apiKey),
                                              URLQueryItem(key: .units, value: "imperial")])
    }
    
    static func search(with city: String, and state: String) -> Endpoint {
        Endpoint(path: .geocode, queryItems: [URLQueryItem(key: .q, value: "\(city), \(state), \(WeatherAPI.countryCode)"),
                                              URLQueryItem(key: .limit, value: "3"),
                                              URLQueryItem(key: .appid, value: WeatherAPI.apiKey)])
    }
    
    static func reverseGeocode(lat: Double, lon: Double) -> Endpoint {
        Endpoint(path: .reverseGeocode, queryItems: [URLQueryItem(key: .lat, value: String(lat)),
                                              URLQueryItem(key: .lon, value: String(lon)),
                                              URLQueryItem(key: .appid, value: WeatherAPI.apiKey)])
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = WeatherAPI.host
        components.path = path.rawValue
        components.queryItems = queryItems
        return components.url
    }
    
    var iconUrl: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = WeatherAPI.iconHost
        components.path = path.rawValue
        components.queryItems = queryItems
        return components.url
    }
}

/// Extending URLQueryItem to be able to use enum keys instead of strings for name
extension URLQueryItem {
    init(key: WeatherAPI.ParameterKey, value: String?) {
        self.init(name: key.rawValue, value: value)
    }
}
