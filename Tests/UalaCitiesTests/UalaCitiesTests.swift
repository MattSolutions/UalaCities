//
//  UalaCitiesTests.swift
//  UalaCitiesTests
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import XCTest
@testable import UalaCities

final class SearchAlgorithmTests: XCTestCase {
    
    private var repository: MockCitiesRepository!
    private var searchUseCase: SearchCitiesUseCase!
    
    override func setUpWithError() throws {
        let testCities = [
            City(id: 1, name: "New York", country: "US", coordinates: Coordinate(latitude: 40.7128, longitude: -74.0060)),
            City(id: 2, name: "Tokyo", country: "JP", coordinates: Coordinate(latitude: 35.6762, longitude: 139.6503)),
            City(id: 3, name: "Paris", country: "FR", coordinates: Coordinate(latitude: 48.8566, longitude: 2.3522)),
            City(id: 4, name: "New Delhi", country: "IN", coordinates: Coordinate(latitude: 28.6139, longitude: 77.2090)),
            City(id: 5, name: "São Paulo", country: "BR", coordinates: Coordinate(latitude: -23.5505, longitude: -46.6333))
        ]
        
        repository = MockCitiesRepository(cities: testCities)
        searchUseCase = TrieSearchCitiesUseCase(repository: repository)
    }
    
    override func tearDownWithError() throws {
        repository = nil
        searchUseCase = nil
    }
    
    /// Tests searching with a variety of valid prefixes
    func testSearchWithValidPrefixes() {
        let testCases = [
            ("new", 2),
            ("to", 1),
            ("p", 1),
            ("s", 1),
            ("pa", 1)
        ]
        
        for (prefix, expectedCount) in testCases {
            let results = searchUseCase.execute(prefix: prefix)
            XCTAssertEqual(results.count, expectedCount, "Search with prefix '\(prefix)' should return \(expectedCount) results")
        }
    }
    
    /// Tests that empty prefix returns all cities
    func testSearchWithEmptyPrefix() {
        let results = searchUseCase.execute(prefix: "")
        XCTAssertEqual(results.count, 5, "Empty prefix should return all cities")
    }
    
    /// Tests that non-matching prefixes return empty results
    func testSearchWithNonMatchingPrefix() {
        let nonMatchingPrefixes = ["xyz", "123", "zzz"]
        
        for prefix in nonMatchingPrefixes {
            let results = searchUseCase.execute(prefix: prefix)
            XCTAssertTrue(results.isEmpty, "Non-matching prefix '\(prefix)' should return empty results")
        }
    }
    
    /// Tests case insensitivity in search
    func testSearchCaseInsensitivity() {
        let caseVariations = [
            ("new", 2),
            ("NEW", 2),
            ("New", 2),
            ("nEw", 2)
        ]
        
        for (prefix, expectedCount) in caseVariations {
            let results = searchUseCase.execute(prefix: prefix)
            XCTAssertEqual(results.count, expectedCount, "Search should be case-insensitive")
        }
    }
    
    /// Tests handling of special characters in search
    func testSearchWithSpecialCharacters() {
        let results = searchUseCase.execute(prefix: "são")
        XCTAssertEqual(results.count, 1, "Should find city with accent marks")
    }
    
    /// Tests asynchronous loading of cities
    func testAsyncLoading() async throws {
        let cities = try await searchUseCase.loadAllCities()
        XCTAssertEqual(cities.count, 5, "Should load all cities asynchronously")
    }
    
    /// Tests that errors from the repository are correctly propagated
    func testAsyncLoadingFailure() async {
        class FailingRepository: CitiesRepository {
            func getAllCities() async throws -> [City] {
                throw NSError(domain: "TestError", code: 0)
            }
            
            func searchCities(prefix: String) -> [City] {
                return []
            }
        }
        
        let useCase = TrieSearchCitiesUseCase(repository: FailingRepository())
        
        do {
            _ = try await useCase.loadAllCities()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}

/// Mock repository for testing
class MockCitiesRepository: CitiesRepository {
    private let cities: [City]
    private let trie = PrefixTrie<City>()
    
    init(cities: [City]) {
        self.cities = cities
        for city in cities {
            trie.insert(city, withKey: city.name.lowercased())
        }
    }
    
    func getAllCities() async throws -> [City] {
        return cities
    }
    
    func searchCities(prefix: String) -> [City] {
        if prefix.isEmpty {
            return cities
        }
        return trie.search(prefix: prefix.lowercased())
    }
}
