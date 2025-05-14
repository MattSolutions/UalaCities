//  DependencyContainer.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

/// Container for managing dependencies
final class DependencyContainer {
    // MARK: - Shared Instance
    
    static let shared = DependencyContainer()
    
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
    
    // MARK: - Initialization
    
    private init() {}
}

/// Property wrapper for injecting dependencies
@propertyWrapper
struct Injected<T> {
    let wrappedValue: T
    
    init() {
        guard let value = DependencyContainer.shared.resolve(T.self) else {
            fatalError("Failed to resolve dependency of type \(String(describing: T.self))")
        }
        self.wrappedValue = value
    }
}

// MARK: - Dependency Resolution

extension DependencyContainer {
    /// Resolves a dependency of the specified type
    func resolve<T>(_ type: T.Type) -> T? {
        switch type {
        case is NetworkService.Type:
            return networkService as? T
        case is UserDefaultsStore.Type:
            return userDefaultsStore as? T
        case is CitiesRepository.Type:
            return citiesRepository as? T
        case is FavoritesRepository.Type:
            return favoritesRepository as? T
        case is SearchCitiesUseCase.Type:
            return searchCitiesUseCase as? T
        case is FavoritesUseCase.Type:
            return favoritesUseCase as? T
        default:
            return nil
        }
    }
}
