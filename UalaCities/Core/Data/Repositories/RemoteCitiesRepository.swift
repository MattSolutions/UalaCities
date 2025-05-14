//
//  RemoteCitiesRepository.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

/// Repository implementation that fetches and caches city data from a remote source and provides search functionality
class RemoteCitiesRepository: CitiesRepository {
    private let networkService: NetworkService
    
    private var citiesURL: URL {
        AppConfig.API.citiesURL
    }
    
    private var cachedCities: [City]?
    private var prefixTrie = PrefixTrie<City>()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getAllCities() async throws -> [City] {
        if let cities = cachedCities {
            return cities
        }
        
        let cityDTOs: [CityDTO] = try await networkService.fetchData(from: citiesURL)
        
        let cities = cityDTOs.map { $0.toDomain() }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }
        
        self.cachedCities = cities
        self.buildSearchTrie(for: cities)
        
        return cities
    }
    
    func searchCities(prefix: String) -> [City] {
        guard let cities = cachedCities else {
            return []
        }
        
        if prefix.isEmpty {
            return cities
        }
        
        return prefixTrie.search(prefix: prefix.lowercased())
    }
    
    private func buildSearchTrie(for cities: [City]) {
        let trie = PrefixTrie<City>()
        
        for city in cities {
            trie.insert(city, withKey: city.name.lowercased())
        }
        
        self.prefixTrie = trie
    }
}
