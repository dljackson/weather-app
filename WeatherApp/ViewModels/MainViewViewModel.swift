//
//  MainViewViewModel.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 9/3/24.
//

import Foundation
import CoreLocation

@Observable
class MainViewViewModel: NSObject {
    var state: ViewMode = .loading
    var error: Error?
    var citySearchText = ""
    var stateSearchText = ""
    var loader = Loader()
    var locationManager: CLLocationManager?
    var locationManagerInitiated = false
    var currentLocation: CLLocation?
    var savedCity: City? {
        UserDefaults.standard.object(forKey: savedCityKey) as? City
    }
    
    // Constants
    let savedCityKey = "savedCity"
    let instructions = "Search weather for any US city"
    let cityTextFieldPlaceholder = "City (Required)"
    let stateTextFieldPlaceholder = "State (Required)"
    
    override init() {
        super.init()
        // Load weather for the city that was last used
        if let city = loadSaved() {
            Task {
                try await loadWeather(from: city)
            }
        } else {
            self.state = .search
        }
         
        setupLocationManager()
    }
    
    /// Takes the user's current location (when given permission and has been updated)
    ///  and loads the current and future weather forecast of that city
    /// - Parameter currentLocation: The user's location injected enable to write tests
    /// - Returns: Void
    public func loadWeather(from currentLocation: CLLocation?) throws {
        let authorizationStatus = locationManager?.authorizationStatus
        guard authorizationStatus != .denied else {
            throw SearchError.locationPermissionDenied
        }
        guard let currentLocation = currentLocation else {
            locationManager?.requestLocation()
            throw SearchError.missingCurrentLocation
        }
        Task {
            let city = try await city(from: Endpoint.reverseGeocode(lat: currentLocation.coordinate.latitude,
                                                                    lon: currentLocation.coordinate.longitude))
            try await loadWeather(from: city)
        }
    }
    
    /// Use this method to search for a US city by its name and state, then load its  weather forecast
    /// - Parameter cityName: A string of the city's name
    /// - Parameter stateName: A string of the state's name
    /// - Returns: Void
    public func search(_ cityName: String,_ stateName: String) throws {
        guard !cityName.isEmpty else {
            throw SearchError.missingCity
        }
        guard !stateName.isEmpty else {
            throw SearchError.missingState
        }
        
        Task {
            let city = try await city(from: Endpoint.search(with: cityName,
                                                            and: stateName))
            try await loadWeather(from: city)
        }
    }
    
    /// Takes the user's current location (when given permission and has been updated)
    ///  and loads the current and future weather forecast of that city
    /// - Parameter currentLocation: The user's location injected enable to write tests
    /// - Returns: Void
    private func loadWeather(from city: City?) async throws {
        guard let city = city else { throw SearchError.missingCity }
        let weather = try await weather(from: Endpoint.weather(for: city.lat,
                                                               lon: city.lon))
        self.resetSearchText()
        self.save(latest: city)
        setView(mode: .weather(city, weather))
    }
    
    /// Loads a city object from the weather API
    /// - Parameter endPoint: An object used for specifying a URL's path and parameters
    /// - Returns: City
    private func city(from endPoint: Endpoint) async throws -> City {
        let cities = try await loader.load(endpoint: endPoint,
                                         type: [City].self)
        guard let city = cities.first else { throw SearchError.missingCity }
        return city
    }
    
    /// Loads a weather object from the weather API
    /// - Parameter endPoint: An object used for specifying a URL's path and parameters
    /// - Returns: Weather
    private func weather(from endpoint: Endpoint) async throws -> Weather {
            return try await loader.load(endpoint: endpoint,
                                                type: Weather.self)
    }
    
    /// Sets the mode coresponding to a view
    /// - Parameter mode: An enum indicating which view is to be shown
    /// - Returns: Void
    private func setView(mode: ViewMode) {
        DispatchQueue.main.async {
            self.state = mode
        }
    }
       
    // Saves the last city the user searched for successfully
    func save(latest city: City) {
        if let encodedCity = try? JSONEncoder().encode(city) {
            UserDefaults.standard.set(encodedCity, forKey: savedCityKey)
        }
    }
    
    // Returns the last city the user searched for successfully
    func loadSaved() -> City? {
        if let data = UserDefaults.standard.object(forKey: savedCityKey) as? Data,
           let savedCity = try? JSONDecoder().decode(City.self, from: data) {
            return savedCity
        } else {
            return nil
        }
    }
    
    // Reset text fields
    func resetSearchText() {
        citySearchText = ""
        stateSearchText = ""
    }
}

extension MainViewViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .denied, .restricted:
            currentLocation = nil
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            print("Handle newly added authorizationStatus case(s)")
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        // Only load the weather from user's current location automatically the first time access is granted.
        if manager.authorizationStatus == .authorizedAlways,
           UserDefaults.standard.bool(forKey: "initialLocationLoad") == false {
            UserDefaults.standard.setValue(true, forKey: "initialLocationLoad")
            try? loadWeather(from: manager.location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
    }
    
    /// Requests user's permission to use location. If permission has previously been granted, then its current location is requested
    /// - Returns: Void
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        if let authorizationStatus = locationManager?.authorizationStatus {
            if authorizationStatus == .notDetermined {
                locationManager?.requestAlwaysAuthorization()
            } else if authorizationStatus == .authorizedAlways {
                locationManager?.requestLocation()
            }
        }
    }
}

extension MainViewViewModel: ProvidesIconURL {
    func iconURL(with name: String) -> URL? {
        Endpoint(path: name, queryItems: nil).iconUrl
    }
}
