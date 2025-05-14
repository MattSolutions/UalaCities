//
//  DefaultCitiesRepository.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

/// Repository implementation that fetches and caches city data from a remote source
/// and provides search functionality with prefix matching
class DefaultCitiesRepository: CitiesRepository {
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

/// Trie data structure for fast prefix searching
class PrefixTrie<T> {
    private class TrieNode {
        var items: [T] = []
        var children: [Character: TrieNode] = [:]
    }
    
    private let root = TrieNode()
    
    func insert(_ item: T, withKey key: String) {
        var current = root
        
        for char in key {
            if current.children[char] == nil {
                current.children[char] = TrieNode()
            }
            current = current.children[char]!
            current.items.append(item)
        }
    }
    
    func search(prefix: String) -> [T] {
        var current = root
        
        for char in prefix {
            guard let next = current.children[char] else {
                return []
            }
            current = next
        }
        
        return current.items
    }
}
