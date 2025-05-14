//
//  CityDTO.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

struct CityDTO: Decodable {
    let _id: Int
    let name: String
    let country: String
    let coord: CoordinateDTO
    
    func toDomain() -> City {
        City(
            id: _id,
            name: name,
            country: country,
            coordinates: coord.toDomain()
        )
    }
}

struct CoordinateDTO: Decodable {
    let lat: Double
    let lon: Double
    
    func toDomain() -> Coordinate {
        Coordinate(latitude: lat, longitude: lon)
    }
}
