//
//  CityDetailsViewModel.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import Foundation
import Combine

@MainActor
final class CityDetailsViewModel: ObservableObject {
    @Published var isFavorite: Bool
    private let city: City
    private let favoritesUseCase: FavoritesUseCase
    private var cancellables = Set<AnyCancellable>()

    init(city: City, favoritesUseCase: FavoritesUseCase) {
        self.city = city
        self.favoritesUseCase = favoritesUseCase
        self.isFavorite = favoritesUseCase.isFavorite(cityId: city.id)
        
        favoritesUseCase.favoritesChanged
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.isFavorite = self.favoritesUseCase.isFavorite(cityId: self.city.id)
            }
            .store(in: &cancellables)

    }
    
    func toggleFavorite() {
        _ = favoritesUseCase.toggleFavorite(cityId: city.id)
    }
}
