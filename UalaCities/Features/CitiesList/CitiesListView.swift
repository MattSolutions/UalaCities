//
//  CitiesListView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI

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
        VStack(spacing: 0) {
            searchBar
            favoritesToggle
            contentView
        }
        .navigationTitle("Cities")
        .task {
            if viewModel.state == .idle {
                await viewModel.loadCities()
            }
        }
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
            searchText: $viewModel.searchText,
            placeholder: "Search for a city..."
        )
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var favoritesToggle: some View {
        Toggle("Show Favorites Only", isOn: $viewModel.showFavoritesOnly)
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
                    }
                }
            }
        }
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
            Text("Loading cities...")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text("Error loading cities")
                .font(.headline)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                Task {
                    await viewModel.loadCities()
                }
            }
            .buttonStyle(.borderedProminent)
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
                .foregroundColor(.secondary)
            
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
            Text("Try a different search term")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var emptyFavoritesView: some View {
        VStack(spacing: 4) {
            Text("No favorite cities")
                .font(.headline)
            Text("Mark some cities as favorites to see them here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var emptyCitiesView: some View {
        Text("No cities available")
            .font(.headline)
    }
}
