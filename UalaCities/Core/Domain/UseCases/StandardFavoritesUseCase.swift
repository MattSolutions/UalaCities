//
//  StandardFavoritesUseCase.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation
import Observation

/// Use case for managing favorite cities
protocol FavoritesUseCase {
    /// The current set of favorite city IDs
    var favorites: Set<Int> { get }
    
    /// Determines if a city is currently a favorite
    func isFavorite(cityId: Int) -> Bool
    
    /// Changes the favorite status of a city
    @discardableResult
    func toggleFavorite(cityId: Int) -> Bool
    
    /// Returns only the favorite cities from a provided collection
    func filterFavorites(cities: [City]) -> [City]
}

@Observable
class StandardFavoritesUseCase: FavoritesUseCase {
    private let repository: FavoritesRepository
    
    var favorites: Set<Int> {
        repository.favorites
    }
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func isFavorite(cityId: Int) -> Bool {
        repository.isFavorite(cityId: cityId)
    }
    
    @discardableResult
    func toggleFavorite(cityId: Int) -> Bool {
        repository.toggleFavorite(cityId: cityId)
    }
    
    func filterFavorites(cities: [City]) -> [City] {
        cities.filter { isFavorite(cityId: $0.id) }
    }
}
