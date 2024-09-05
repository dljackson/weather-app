//
//  Loader.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 9/5/24.
//

import Foundation

struct Loader {
    /// Fetches and decodes data from a URL
    /// - Parameter endpoint: An object that supplies the URL
    /// - Parameter type: The type of object to decode data into
    /// - Returns: An object of the the given type
    func load<T: Decodable>(endpoint: Endpoint, type: T.Type) async throws -> T {
        guard let url = endpoint.url else { throw SearchError.invalidURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
