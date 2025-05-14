//
//  UserDefaultsStore.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation
import Observation

/// Service for persisting data using UserDefaults
@Observable
class UserDefaultsStore {
    private let defaults: UserDefaults
    private let favoritesKey = "UalaCities.FavoriteCities"
    
    private var _favorites: Set<Int> = []
    
    var favorites: Set<Int> {
        get { _favorites }
        set {
            _favorites = newValue
            saveFavorites()
        }
    }
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        loadFavorites()
    }
    
    private func loadFavorites() {
        if let data = defaults.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode(Set<Int>.self, from: data) {
            _favorites = favorites
        }
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(_favorites) {
            defaults.set(data, forKey: favoritesKey)
        }
    }
}
