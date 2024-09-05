//
//  SearchError.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 9/5/24.
//

import Foundation

enum SearchError: Error {
    case invalidURL
    case missingCity
    case missingState
    case missingCurrentLocation
    case locationPermissionDenied
    case restricted
}

extension SearchError: LocalizedError {
    public var errorDescription: String? {
            switch self {
            case .invalidURL:
                return NSLocalizedString("The URL supplied is invalid.", comment: "URL error")
            case .missingCity:
                return NSLocalizedString("Please enter a city name.", comment: "Missing city error")
            case .missingState:
                return NSLocalizedString("Please enter a state name.", comment: "Missing state")
            case .missingCurrentLocation:
                return NSLocalizedString("The user's current location could not be found.", comment: "Missing current locatioin")
            case .locationPermissionDenied:
                return NSLocalizedString("Please update your authorization status in settings .", comment: "Status error")
            case .restricted:
                return NSLocalizedString("Sorry, this device doe not support user locations.", comment: "Location error")
            }
        }
}
