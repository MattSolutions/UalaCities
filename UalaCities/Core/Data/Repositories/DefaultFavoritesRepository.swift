//
//  DefaultFavoritesRepository.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation
import Observation

/// Repository implementation that manages user's favorite cities
/// using UserDefaults for persistence across app launches
@Observable
class DefaultFavoritesRepository: FavoritesRepository {
    private let storage: UserDefaultsStore
    
    /// Observable collection of favorite city IDs
    var favorites: Set<Int> {
        get { storage.favorites }
        set { storage.favorites = newValue }
    }
    
    init(storage: UserDefaultsStore) {
        self.storage = storage
    }
    
    func isFavorite(cityId: Int) -> Bool {
        favorites.contains(cityId)
    }
    
    @discardableResult
    func toggleFavorite(cityId: Int) -> Bool {

        var updatedFavorites = favorites
        let wasAdded = updatedFavorites.update(with: cityId) == nil
        
        storage.favorites = updatedFavorites
        
        return wasAdded
    }
}
