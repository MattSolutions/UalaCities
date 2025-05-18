//
//  MainView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Properties
    
    @StateObject private var coordinator = CitiesCoordinator()
    private let searchUseCase: SearchCitiesUseCase
    private let favoritesUseCase: FavoritesUseCase
    
    // MARK: - Initialization
    
    init(searchUseCase: SearchCitiesUseCase, favoritesUseCase: FavoritesUseCase) {
        self.searchUseCase = searchUseCase
        self.favoritesUseCase = favoritesUseCase
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                if geometry.size.width > geometry.size.height {
                    LandscapeLayout(
                        searchUseCase: searchUseCase,
                        favoritesUseCase: favoritesUseCase
                    )
                } else {
                    PortraitLayout(
                        searchUseCase: searchUseCase,
                        favoritesUseCase: favoritesUseCase
                    )
                }
            }
            .environmentObject(coordinator)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                coordinator.clearNavigationAndSelection()
            }
        }
    }
}

// MARK: - Layout Components

struct PortraitLayout: View {
    @EnvironmentObject var coordinator: CitiesCoordinator
    let searchUseCase: SearchCitiesUseCase
    let favoritesUseCase: FavoritesUseCase
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            CitiesListView(
                searchUseCase: searchUseCase,
                favoritesUseCase: favoritesUseCase
            )
            .navigationDestination(for: CitiesCoordinator.Destination.self) { destination in
                switch destination {
                case .map:
                    CityMapView()
                case .details(let city):
                    CityDetailsView(
                        city: city,
                        favoritesUseCase: favoritesUseCase
                    )
                }
            }
        }
    }
}

struct LandscapeLayout: View {
    @EnvironmentObject var coordinator: CitiesCoordinator
    let searchUseCase: SearchCitiesUseCase
    let favoritesUseCase: FavoritesUseCase
    
    var body: some View {
        HStack(spacing: 0) {
            CitiesListView(
                searchUseCase: searchUseCase,
                favoritesUseCase: favoritesUseCase
            )
            .frame(maxWidth: .infinity)
            
            CityMapView()
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity)
        }
        .sheet(item: $coordinator.cityForDetails) { city in
            CityDetailsView(
                city: city,
                favoritesUseCase: favoritesUseCase
            )
        }
    }
}
