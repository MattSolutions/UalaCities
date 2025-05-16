//
//  StandardFavoritesUseCase.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation
import Combine

/// Use case for managing favorite cities
protocol FavoritesUseCase {
    var favorites: Set<Int> { get }
    var favoritesChanged: AnyPublisher<Void, Never> { get }
    
    func isFavorite(cityId: Int) -> Bool
    @discardableResult
    func toggleFavorite(cityId: Int) -> Bool
    func filterFavorites(cities: [City]) -> [City]
}

class StandardFavoritesUseCase: FavoritesUseCase {
    private let repository: FavoritesRepository
    private var cancellables = Set<AnyCancellable>() 
    
    private let favoritesChangedSubject = PassthroughSubject<Void, Never>()
    
    var favoritesChanged: AnyPublisher<Void, Never> {
        favoritesChangedSubject
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    var favorites: Set<Int> {
        repository.favorites
    }
    
    init(repository: FavoritesRepository) {
        self.repository = repository
        
        repository.favoritesChanged
            .sink { [weak self] in
                self?.favoritesChangedSubject.send()
            }
            .store(in: &cancellables)
    }
    
    func isFavorite(cityId: Int) -> Bool {
        repository.isFavorite(cityId: cityId)
    }
    
    @discardableResult
    func toggleFavorite(cityId: Int) -> Bool {
        let result = repository.toggleFavorite(cityId: cityId)
        
        favoritesChangedSubject.send()
        
        return result
    }
    
    func filterFavorites(cities: [City]) -> [City] {
        let currentFavorites = favorites
        return cities.filter { currentFavorites.contains($0.id) }
    }
}
