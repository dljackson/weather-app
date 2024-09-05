//
//  SearchView.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 9/3/24.
//

import SwiftUI

struct SearchView: View {
    @Binding var viewModel: MainViewViewModel
    @State var didFail = false
    @State var searchError: SearchError?
    
    
    var body: some View {
        
        VStack {
            // MARK: Current location button
            Text(viewModel.instructions)
                .padding()
            
            // MARK: Search text fields
            TextField(viewModel.cityTextFieldPlaceholder,
                      text: $viewModel.citySearchText)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
            TextField(viewModel.stateTextFieldPlaceholder,
                      text: $viewModel.stateSearchText)
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
            
            // MARK: Search button
            Button("Search") {
                do {
                    try viewModel.search(viewModel.citySearchText,
                                         viewModel.stateSearchText)
                } catch {
                    didFail = true
                    self.searchError = (error as? SearchError)
                }
            }
            .buttonStyle(.bordered)
            
            // MARK: Use user's location button
            Button("Use current location", systemImage: "location") {
                do {
                    try viewModel.loadWeather(from: viewModel.currentLocation)
                } catch {
                    didFail = true
                    self.searchError = (error as? SearchError)
                }
            }
            .padding(.top)
        }
        .alert("Error", isPresented: $didFail) {
            Button("Done", role: .cancel) {
                
            }
        } message: {
            Text(self.searchError?.errorDescription ?? "")
        }
    }
}

#Preview {
    SearchView(viewModel: .constant(MainViewViewModel()))
}
