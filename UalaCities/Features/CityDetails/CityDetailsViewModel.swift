//
//  CityDetailsViewModel.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import Foundation
import SwiftUI

final class CityDetailsViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var isFavorite: Bool = false
    
    // MARK: - Dependencies
    
    private let city: City
    private let favoritesUseCase: FavoritesUseCase
    
    // MARK: - Initialization
    
    init(city: City, favoritesUseCase: FavoritesUseCase) {
        self.city = city
        self.favoritesUseCase = favoritesUseCase
        self.isFavorite = favoritesUseCase.isFavorite(cityId: city.id)
    }
    
    // MARK: - Public Methods
    
    @MainActor
    func toggleFavorite() {
        favoritesUseCase.toggleFavorite(cityId: city.id)
        isFavorite = favoritesUseCase.isFavorite(cityId: city.id)
    }
}
