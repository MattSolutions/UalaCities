//
//  ContentView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var coordinator = CitiesCoordinator()
    @State private var isLandscape = false
    private let searchUseCase: SearchCitiesUseCase
    private let favoritesUseCase: FavoritesUseCase
    
    init(searchUseCase: SearchCitiesUseCase, favoritesUseCase: FavoritesUseCase) {
        self.searchUseCase = searchUseCase
        self.favoritesUseCase = favoritesUseCase
    }
    
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
        }
    }
}

// Layout components using EnvironmentObject
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
            
            MapView()
                .frame(maxWidth: .infinity)
        }
        .sheet(item: Binding(
            get: { coordinator.selectedCity },
            set: { coordinator.selectedCity = $0 }
        )) { city in
            CityDetailView(city: city)
        }
    }
}

struct PortraitLayout: View {
    @EnvironmentObject var coordinator: CitiesCoordinator
    let searchUseCase: SearchCitiesUseCase
    let favoritesUseCase: FavoritesUseCase
    
    var body: some View {
        NavigationStack {
            CitiesListView(
                searchUseCase: searchUseCase,
                favoritesUseCase: favoritesUseCase
            )
            .navigationDestination(for: CitiesCoordinator.NavigationDestination.self) { destination in
                switch destination {
                case .map:
                    MapView()
                case .details(let city):
                    CityDetailView(city: city)
                case .none:
                    EmptyView()
                }
            }
        }
    }
}
