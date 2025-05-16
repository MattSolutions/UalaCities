//
//  UserDefaultsStore.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation
import Combine

/// Service for persisting data using UserDefaults
class UserDefaultsStore {
    // MARK: - Properties
    
    private let defaults: UserDefaults
    private let favoritesKey = "UalaCities.FavoriteCities"
    
    private lazy var favoritesSubject = CurrentValueSubject<Set<Int>, Never>(loadFavoritesSet())
    
    var favoritesPublisher: AnyPublisher<Set<Int>, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    var favorites: Set<Int> {
        get { favoritesSubject.value }
        set {
            guard newValue != favoritesSubject.value else { return }
            
            saveFavorites(newValue)
            favoritesSubject.send(newValue)
        }
    }
    
    // MARK: - Initialization
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // MARK: - Private Methods
    
    private func loadFavoritesSet() -> Set<Int> {
        guard let data = defaults.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode(Set<Int>.self, from: data) else {
            return []
        }
        return favorites
    }
    
    private func saveFavorites(_ favorites: Set<Int>) {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        defaults.set(data, forKey: favoritesKey)
        defaults.synchronize()
    }
}
