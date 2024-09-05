//
//  Protocols.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 9/5/24.
//

import Foundation

protocol ProvidesIconURL {
    func iconURL(with name: String) -> URL? 
}
