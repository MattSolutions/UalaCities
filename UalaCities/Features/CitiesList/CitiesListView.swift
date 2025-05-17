//
//  CitiesListView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI
import Combine

struct CitiesListView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var coordinator: CitiesCoordinator
    @StateObject private var viewModel: CitiesListViewModel
    
    init(searchUseCase: SearchCitiesUseCase, favoritesUseCase: FavoritesUseCase) {
        _viewModel = StateObject(wrappedValue: CitiesListViewModel(
            searchUseCase: searchUseCase,
            favoritesUseCase: favoritesUseCase
        ))
    }
    
    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundView
            contentStack
        }
        .task {
            if viewModel.state == .idle {
                await viewModel.loadCities()
            }
        }
    }
    
    // MARK: - Background Components

    private var backgroundView: some View {
        Color.ualaBrand
            .overlay(
                Image("cityscape")
                    .resizable()
                    .scaledToFill()
                    .colorMultiply(Color.ualaBrand)
                    .opacity(0.9)
            )
            .overlay(Color.ualaBrandGradient)
            .ignoresSafeArea()
    }

    // MARK: - Content Components

    private var contentStack: some View {
        VStack(spacing: 0) {
            headerTitle
            searchBar
                .padding(.vertical, 8)
            favoritesToggle
                .padding(.bottom, 8)
            contentView
        }
        .padding(.horizontal, 24)
    }

    private var headerTitle: some View {
        Text("Cities")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.ualaPrimaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 16)
            .padding(.bottom, 8)
    }
    
    // MARK: - Content Building
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .error(let message):
            errorView(message: message)
        case .idle, .loaded:
            citiesListView
        }
    }
    
    @ViewBuilder
    private var citiesListView: some View {
        if viewModel.filteredCities.isEmpty {
            emptyStateView
        } else {
            citiesList
        }
    }
    
    // MARK: - UI Components
    
    private var searchBar: some View {
        SearchBar(
            searchText: $viewModel.searchText
        )
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var favoritesToggle: some View {
        Toggle("Show Favorites Only", isOn: $viewModel.showFavoritesOnly)
            .toggleStyle(SwitchToggleStyle(tint: Color.ualaAccent))
            .foregroundColor(.ualaPrimaryText)
            .padding(.horizontal)
            .padding(.bottom, 8)
            .animation(.easeInOut(duration: 0.2), value: viewModel.showFavoritesOnly)
    }
    
    private var citiesList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredCities.prefix(viewModel.itemsToShow)) { city in
                    VStack(spacing: 0) {
                        cityRow(for: city)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .onAppear {
                                viewModel.loadMoreItemsIfNeeded(for: city)
                            }
                        
                        Divider()
                            .padding(.leading)
                            .background(Color.ualaSecondaryText)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .animation(.easeOut(duration: 0.25), value: viewModel.filteredCities.count)
    }
    
    private func cityRow(for city: City) -> some View {
        let identity = viewModel.identityFor(city)
        
        return CityRow(
            city: city,
            isFavorite: identity.isFavorite,
            isSelected: viewModel.selectedCity?.id == city.id,
            onToggleFavorite: {
                viewModel.toggleFavorite(for: city)
            },
            onShowDetails: {
                viewModel.selectCity(city)
                coordinator.showCityDetails(city)
            }
        )
        .id(identity)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectCity(city)
            coordinator.showCityOnMap(city)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            Text("Loading cities...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(Color.ualaAccent)
            
            Text("Error loading cities")
                .font(.headline)
                .foregroundColor(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.ualaSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                Task {
                    await viewModel.loadCities()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.ualaAccent)
            .foregroundColor(.white)
            .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.white)
            
            if !viewModel.searchText.isEmpty {
                emptySearchView
            } else if viewModel.showFavoritesOnly {
                emptyFavoritesView
            } else {
                emptyCitiesView
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptySearchView: some View {
        VStack(spacing: 4) {
            Text("No cities found")
                .font(.headline)
                .foregroundColor(.white)
            Text("Try a different search term")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    private var emptyFavoritesView: some View {
        VStack(spacing: 4) {
            Text("No favorite cities")
                .font(.headline)
                .foregroundColor(.white)
            Text("Mark some cities as favorites to see them here")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    private var emptyCitiesView: some View {
        Text("No cities available")
            .font(.headline)
            .foregroundColor(.white)
    }
}


// MARK: - Preview Provider
#Preview(traits: .landscapeLeft) {
    CitiesListView(
        searchUseCase: PreviewSearchCitiesUseCase(),
        favoritesUseCase: PreviewFavoritesUseCase()
    )
    .environmentObject(CitiesCoordinator())
}

#Preview(traits: .portrait) {
    NavigationStack {
        CitiesListView(
            searchUseCase: PreviewSearchCitiesUseCase(),
            favoritesUseCase: PreviewFavoritesUseCase()
        )
        .environmentObject(CitiesCoordinator())
    }
}

// MARK: - Preview Implementations

private class PreviewSearchCitiesUseCase: SearchCitiesUseCase {
    private let mockCities = [
        City(id: 1, name: "New York", country: "US",
             coordinates: Coordinate(latitude: 40.7128, longitude: -74.0060)),
        City(id: 2, name: "London", country: "UK",
             coordinates: Coordinate(latitude: 51.5074, longitude: -0.1278)),
        City(id: 3, name: "Tokyo", country: "JP",
             coordinates: Coordinate(latitude: 35.6762, longitude: 139.6503)),
        City(id: 4, name: "Paris", country: "FR",
             coordinates: Coordinate(latitude: 48.8566, longitude: 2.3522)),
        City(id: 5, name: "Sydney", country: "AU",
             coordinates: Coordinate(latitude: -33.8688, longitude: 151.2093))
    ]
    
    func execute(prefix: String) -> [City] {
        if prefix.isEmpty {
            return mockCities
        }
        return mockCities.filter { $0.name.lowercased().hasPrefix(prefix.lowercased()) }
    }
    
    func loadAllCities() async throws -> [City] {
        return mockCities
    }
}

private class PreviewFavoritesUseCase: FavoritesUseCase {
    private let favoritesSubject = PassthroughSubject<Void, Never>()
    private var favoritesSet: Set<Int> = [1, 3] // New York and Tokyo are favorites by default
    
    var favorites: Set<Int> {
        favoritesSet
    }
    
    var favoritesChanged: AnyPublisher<Void, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    func isFavorite(cityId: Int) -> Bool {
        favorites.contains(cityId)
    }
    
    @discardableResult
    func toggleFavorite(cityId: Int) -> Bool {
        let wasAdded: Bool
        if favorites.contains(cityId) {
            favoritesSet.remove(cityId)
            wasAdded = false
        } else {
            favoritesSet.insert(cityId)
            wasAdded = true
        }
        
        favoritesSubject.send()
        
        return wasAdded
    }
    
    func filterFavorites(cities: [City]) -> [City] {
        cities.filter { favorites.contains($0.id) }
    }
}
