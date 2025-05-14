//
//  AppConfig.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

/// Application configuration
enum AppConfig {
    
    enum API {
        /// URL for fetching cities data
        static var citiesURL: URL {
            guard let url = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json") else {
                fatalError("Invalid cities URL configuration")
            }
            return url
        }
    }
}
