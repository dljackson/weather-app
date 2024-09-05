//
//  ViewController.swift
//  WeatherApp
//
//  Created by Dustin Jackson on 8/30/24.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let hostView = UIHostingController(rootView: MainView(viewModel: MainViewViewModel()))
        let weatherView = hostView.view!
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostView)
        view.addSubview(weatherView)
        
        NSLayoutConstraint.activate([
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        hostView.didMove(toParent: self)
    }


}

