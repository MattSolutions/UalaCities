//  DependencyContainer.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

/// Container for managing dependencies
final class DependencyContainer {
    // MARK: - Services
    
    lazy var networkService: NetworkService = {
        URLNetworkService()
    }()
    
    lazy var userDefaultsStore: UserDefaultsStore = {
        UserDefaultsStore()
    }()
    
    // MARK: - Repositories
    
    lazy var citiesRepository: CitiesRepository = {
        RemoteCitiesRepository(networkService: networkService)
    }()
    
    lazy var favoritesRepository: FavoritesRepository = {
        UserDefaultsFavoritesRepository(storage: userDefaultsStore)
    }()
    
    // MARK: - Use Cases
    
    lazy var searchCitiesUseCase: SearchCitiesUseCase = {
        TrieSearchCitiesUseCase(repository: citiesRepository)
    }()
    
    lazy var favoritesUseCase: FavoritesUseCase = {
        StandardFavoritesUseCase(repository: favoritesRepository)
    }()
}
