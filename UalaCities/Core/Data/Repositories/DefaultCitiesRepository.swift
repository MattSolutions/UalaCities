//
//  DefaultCitiesRepository.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

/// Default implementation of CitiesRepository that fetches cities from a remote source
class DefaultCitiesRepository: CitiesRepository {
    private let networkService: NetworkService
    
    private var citiesURL: URL {
        AppConfig.API.citiesURL
    }
    
    private var cachedCities: [City]?
    
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
        
        return cities
    }
    
    func searchCities(prefix: String) -> [City] {
        guard let cities = cachedCities, !prefix.isEmpty else {
            return cachedCities ?? []
        }
        
        let lowercasedPrefix = prefix.lowercased()
        return cities.filter { $0.name.lowercased().hasPrefix(lowercasedPrefix) }
    }
}
