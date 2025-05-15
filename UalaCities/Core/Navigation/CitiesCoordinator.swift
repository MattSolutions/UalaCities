//
//  CitiesCoordinator.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI
import Combine
import MapKit

/// Coordinates navigation between the cities list, details and map views.
@MainActor
class CitiesCoordinator: ObservableObject {

    // MARK: - Navigation Destination

    enum NavigationDestination: Equatable {
        case none
        case map
        case details(City)
        
        static func == (lhs: NavigationDestination, rhs: NavigationDestination) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none):
                return true
            case (.map, .map):
                return true
            case let (.details(lhsCity), .details(rhsCity)):
                return lhsCity.id == rhsCity.id
            default:
                return false
            }
        }
    }
    
    // MARK: - Published Properties

    @Published private(set) var navigationDestination: NavigationDestination = .none
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    // MARK: - Navigation Actions

    func showCityDetails(_ city: City) {
        navigationDestination = .details(city)
    }
    
    func showCityOnMap(_ city: City) {
        mapRegion = MKCoordinateRegion(
            center: city.coordinates.clLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        navigationDestination = .map
    }
    
    func backToList() {
        navigationDestination = .none
    }

    // MARK: - Computed Properties

    var isShowingMap: Bool {
        get {
            if case .map = navigationDestination { return true }
            return false
        }
        set {
            if newValue {
                navigationDestination = .map
            } else if case .map = navigationDestination {
                navigationDestination = .none
            }
        }
    }
    
    var selectedCity: City? {
        get {
            if case .details(let city) = navigationDestination { return city }
            return nil
        }
        set {
            if let city = newValue {
                navigationDestination = .details(city)
            } else if case .details = navigationDestination {
                navigationDestination = .none
            }
        }
    }
}
