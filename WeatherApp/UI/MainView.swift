//
//  MainView.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 9/3/24.
//

import SwiftUI

enum ViewMode {
    case loading
    case weather(City, Weather)
    case search
}

struct MainView: View {
    @State var viewModel: MainViewViewModel
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .weather(let city, let weather):
                CityWeatherView(city: city,
                                weather: weather,
                                viewModel: viewModel,
                                viewMode: $viewModel.state)
            case .search:
                SearchView(viewModel: $viewModel)
            }
        }
    }
}

#Preview {
    MainView(viewModel: MainViewViewModel())
}
