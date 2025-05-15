//
//  CitiesCoordinator.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI
import MapKit

@MainActor
final class CitiesCoordinator: ObservableObject {
    // MARK: - Navigation State
    
    @Published var navigationPath = NavigationPath()
    @Published var selectedCity: City?
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    // MARK: - Destination Types
    
    enum Destination: Hashable {
        case map
        case details(City)
        
        static func == (lhs: Destination, rhs: Destination) -> Bool {
            switch (lhs, rhs) {
            case (.map, .map):
                return true
            case let (.details(lhsCity), .details(rhsCity)):
                return lhsCity.id == rhsCity.id
            default:
                return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .map:
                hasher.combine(0)
            case .details(let city):
                hasher.combine(1)
                hasher.combine(city.id)
            }
        }
    }
    
    // MARK: - Navigation Actions
    
    /// Shows the city details screen.
    /// - In portrait: Pushes details onto navigation stack
    /// - In landscape: Shows city details in a sheet
    func showCityDetails(_ city: City) {
        selectedCity = city
        navigationPath.append(Destination.details(city))
    }

    /// Shows the map focused on the specified city.
    /// - In portrait: Pushes map view onto navigation stack
    /// - In landscape: Updates the map region to show the city
    func showCityOnMap(_ city: City) {
        selectedCity = city
        updateMapRegion(for: city)
        navigationPath.append(Destination.map)
    }
    
    func backToList() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateMapRegion(for city: City) {
        mapRegion = MKCoordinateRegion(
            center: city.coordinates.clLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}
