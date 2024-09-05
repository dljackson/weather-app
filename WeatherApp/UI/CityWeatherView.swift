//
//  CityWeatherView.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 8/31/24.
//

import SwiftUI
import Combine

struct CityWeatherView: View {
    var city: City
    var weather: Weather
    var viewModel: ProvidesIconURL
    @Binding var viewMode: ViewMode
    
    let textColor = Color(#colorLiteral(red: 0.2363693714, green: 0.3685636222, blue: 0.8072679043, alpha: 1))
    let bgColor = Color(#colorLiteral(red: 0.7531765103, green: 0.8467922807, blue: 0.9729946256, alpha: 1))
    let screenBgColor = Color(#colorLiteral(red: 0.7998180985, green: 0.9034408927, blue: 1, alpha: 1))
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    // MARK: Current weather view
                    VStack(alignment: .center) {
                        Text(city.name)
                            .font(.system(size: 30))
                        Text(String(format: " %.0f°", weather.current.temp ?? "N/A"))
                            .font(.system(size: 65))
                        HStack {
                            if let iconName = weather.current.weather.first?.icon {
                                AsyncImage(url: viewModel.iconURL(with: iconName)) { result in
                                    result.image?
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            
                            Text(weather.current.weather.first?.description.localizedCapitalized ?? "N/A")
                                .font(.system(size: 20))
                        }
                        .padding(.top, -40)
                    }
                    .padding(.top, 20)
                    
                    // MARK: Hourly weather view
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(weather.hourly, id: \.dt) { forecast in
                                VStack {
                                    Text(String(forecast.hour))
                                    if let iconName = forecast.weather.first?.icon {
                                        AsyncImage(url: viewModel.iconURL(with: iconName)) { result in
                                            result.image?
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                    Text(String(format: "%.0f°", forecast.temp ?? "N/A"))
                                }
                            }
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(bgColor)
                        
                    }
                    .padding()
                    
                    // MARK: Daily weather view
                    VStack {
                        ForEach(weather.daily, id: \.dt) { forecast in
                            HStack {
                                Text(forecast.day)
                                    .frame(width: 100, alignment: .leading)
                                Spacer()
                                
                                if let iconName = forecast.weather.first?.icon {
                                    AsyncImage(url: viewModel.iconURL(with: iconName)) { result in
                                        result.image?
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    }
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                }
                                Spacer()
                                Text(String(format: "%.0f° Lo", forecast.tempDetails?.min ?? "N/A"))
                                Spacer()
                                Text(String(format: "%.0f° Hi", forecast.tempDetails?.max ?? "N/A"))
                            }
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(bgColor)
                    }
                    .padding()
                }
            }
            .foregroundStyle(textColor)
            .background(screenBgColor)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            DispatchQueue.main.async {
                                self.viewMode = .search
                            }
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            })
        }
    }
}

#Preview {
    let forecast = Forecast(dt: 1725141600.0,
                            sunrise: nil,
                            sunset: nil,
                            temp: Optional(79.84),
                            tempDetails: nil,
                            weather: [Forecast.Description(main: "Clouds", description: "scattered clouds", icon: "01d")])
    let forecast2 = Forecast(dt: 1725141600.0,
                            sunrise: nil,
                            sunset: nil,
                            temp: nil,
                             tempDetails: Forecast.TemperatureDetails(min: 73.43, max: 88.7, morn: 73.43, day: 88.7, night: 81.24),
                            weather: [Forecast.Description(main: "Clouds", description: "scattered clouds", icon: "04d")])
    let forecast3 = Forecast(dt: 1724141600.0,
                            sunrise: nil,
                            sunset: nil,
                            temp: nil,
                             tempDetails: Forecast.TemperatureDetails(min: 73.43, max: 88.7, morn: 73.43, day: 88.7, night: 81.24),
                            weather: [Forecast.Description(main: "Clouds", description: "scattered clouds", icon: "10d")])
    let forecast4 = Forecast(dt: 1725141600.0,
                            sunrise: nil,
                            sunset: nil,
                            temp: nil,
                             tempDetails: Forecast.TemperatureDetails(min: 73.43, max: 88.7, morn: 73.43, day: 88.7, night: 81.24),
                            weather: [Forecast.Description(main: "Clouds", description: "scattered clouds", icon: "04n")])
    let forecast5 = Forecast(dt: 1726141600.0,
                            sunrise: nil,
                            sunset: nil,
                            temp: nil,
                             tempDetails: Forecast.TemperatureDetails(min: 73.43, max: 88.7, morn: 73.43, day: 88.7, night: 81.24),
                            weather: [Forecast.Description(main: "Clouds", description: "scattered clouds", icon: "01d")])
    let forecast6 = Forecast(dt: 1726141600.0,
                            sunrise: nil,
                            sunset: nil,
                            temp: nil,
                             tempDetails: Forecast.TemperatureDetails(min: 73.43, max: 88.7, morn: 73.43, day: 88.7, night: 81.24),
                            weather: [Forecast.Description(main: "Clouds", description: "scattered clouds", icon: "03d")])
    let weather = Weather(current: forecast,
                          hourly: [forecast, forecast, forecast, forecast],
                          daily: [forecast2, forecast3, forecast4, forecast5, forecast6, forecast2])
    let city = City(name: "Plano",
                    lon: 37.1289771,
                    lat: -84.0832646)
    
    @State var mode: ViewMode = .weather(city, weather)
    
    return CityWeatherView(city: city,
                           weather: weather,
                           viewModel: MainViewViewModel(),
                           viewMode: $mode)
}
