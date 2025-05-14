//
//  FavoritesRepository.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation
import Observation

/// Repository interface for accessing favorite cities
protocol FavoritesRepository {
    /// Observable collection of favorite city IDs
    var favorites: Set<Int> { get }
    
    /// Checks if a city is marked as favorite
    func isFavorite(cityId: Int) -> Bool
    
    /// Toggles the favorite status of a city
    @discardableResult
    func toggleFavorite(cityId: Int) -> Bool
}
