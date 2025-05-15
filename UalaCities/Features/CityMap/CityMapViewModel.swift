//
//  CityMapViewModel.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import Foundation
import SwiftUI

@MainActor
final class CityMapViewModel: ObservableObject {
    @Published private(set) var mapPins: [City] = []
    
    /// Updates the cities displayed as pins on the map
    func updateMapPin(_ city: City?) {
        mapPins = city.map { [$0] } ?? []
    }
}
