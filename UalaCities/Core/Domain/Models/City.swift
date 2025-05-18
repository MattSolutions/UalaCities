//
//  City.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation
import CoreLocation

struct City: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let country: String
    let coordinates: Coordinate
    
    var displayName: String {
        "\(name), \(country)"
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Sorting

extension City {
    /// Sorts cities with alphabetical names first, followed by cities with special characters
    static func sortAlphabetically(lhs: City, rhs: City) -> Bool {
        let lhsPriority = lhs.name.first?.isLetter == true ? 0 : 1
        let rhsPriority = rhs.name.first?.isLetter == true ? 0 : 1
        
        if lhsPriority != rhsPriority {
            return lhsPriority < rhsPriority
        }
        
        return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
    }
}

struct CityIdentity: Hashable {
    let id: Int
    let isFavorite: Bool
    
    init(city: City, isFavorite: Bool) {
        self.id = city.id
        self.isFavorite = isFavorite
    }
}

struct Coordinate: Equatable, Hashable {
    let latitude: Double
    let longitude: Double
    
    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
