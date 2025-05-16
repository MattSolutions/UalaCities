//
//  UserDefaultsFavoritesRepository.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation
import Combine

/// Repository implementation that manages user's favorite cities
/// using UserDefaults for persistence
class UserDefaultsFavoritesRepository: FavoritesRepository {
    // MARK: - Properties
    
    private let storage: UserDefaultsStore
    
    // MARK: - Protocol Conformance
    
    var favoritesChanged: AnyPublisher<Void, Never> {
        return storage.favoritesPublisher
            .dropFirst()
            .map { _ in () }
            .share()
            .eraseToAnyPublisher()
    }
    
    var favorites: Set<Int> {
        storage.favorites
    }
    
    // MARK: - Initialization
    init(storage: UserDefaultsStore) {
        self.storage = storage
    }
    
    // MARK: - Public Methods
    
    func isFavorite(cityId: Int) -> Bool {
        favorites.contains(cityId)
    }
    
    @discardableResult
    func toggleFavorite(cityId: Int) -> Bool {
        var updatedFavorites = favorites
        let isCurrentlyFavorite = updatedFavorites.contains(cityId)
        
        if isCurrentlyFavorite {
            updatedFavorites.remove(cityId)
        } else {
            updatedFavorites.insert(cityId)
        }
        
        storage.favorites = updatedFavorites
        
        return !isCurrentlyFavorite
    }
}
