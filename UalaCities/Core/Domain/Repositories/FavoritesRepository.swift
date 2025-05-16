//
//  FavoritesRepository.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation
import Combine

/// Repository interface for accessing favorite cities
protocol FavoritesRepository {
    var favorites: Set<Int> { get }
    var favoritesChanged: AnyPublisher<Void, Never> { get }
    
    func isFavorite(cityId: Int) -> Bool
    @discardableResult
    func toggleFavorite(cityId: Int) -> Bool
}
