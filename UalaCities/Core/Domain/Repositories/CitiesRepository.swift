//
//  CitiesRepository.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

/// Repository interface for accessing city data
protocol CitiesRepository {
    /// Fetches all cities from the data source
    func getAllCities() async throws -> [City]
    
    /// Searches cities with a given prefix
    func searchCities(prefix: String) -> [City]
}
