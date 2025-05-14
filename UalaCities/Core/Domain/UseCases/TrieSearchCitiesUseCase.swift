//
//  TrieSearchCitiesUseCase.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

/// Use case for searching cities by prefix
protocol SearchCitiesUseCase {
    /// Executes the search with the given prefix
    func execute(prefix: String) -> [City]
    
    /// Loads all cities from the repository
    func loadAllCities() async throws -> [City]
}

class TrieSearchCitiesUseCase: SearchCitiesUseCase {
    private let repository: CitiesRepository
    
    init(repository: CitiesRepository) {
        self.repository = repository
    }
    
    func execute(prefix: String) -> [City] {
        repository.searchCities(prefix: prefix)
    }
    
    func loadAllCities() async throws -> [City] {
        try await repository.getAllCities()
    }
}
