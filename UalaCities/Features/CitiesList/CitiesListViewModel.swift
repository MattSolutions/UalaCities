//
//  CitiesListViewModel.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import Foundation
import Combine

@MainActor
final class CitiesListViewModel: ObservableObject {
    
    // MARK: - State Management
    
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    // MARK: - Published Properties
    
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var cities: [City] = []
    @Published private(set) var filteredCities: [City] = []
    @Published private(set) var selectedCity: City?
    
    // MARK: - Pagination Properties
    
    @Published private(set) var itemsToShow: Int = 100
    private let batchSize: Int = 50
    
    // MARK: - Dependencies
    
    private let searchUseCase: SearchCitiesUseCase
    private let favoritesUseCase: FavoritesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    init(searchUseCase: SearchCitiesUseCase, favoritesUseCase: FavoritesUseCase) {
        self.searchUseCase = searchUseCase
        self.favoritesUseCase = favoritesUseCase
        
        setupPublishers()
        Task {
            do {
                cities = try await searchUseCase.loadAllCities()
                state = .loaded
                filterCities()
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Setup

    private func setupPublishers() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterCities()
            }
            .store(in: &cancellables)
        
        $showFavoritesOnly
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterCities()
            }
            .store(in: &cancellables)
        
        favoritesUseCase.favoritesChanged
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.filterCities()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Data Loading
    
    func loadCities() async {
        guard state != .loading else {
            return
        }
        
        state = .loading
        
        do {
            cities = try await searchUseCase.loadAllCities()
            state = .loaded
            filterCities()
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    // MARK: - Filtering
    
    func filterCities() {

        if searchText.isEmpty && !showFavoritesOnly {
            filteredCities = cities
            itemsToShow = min(100, cities.count)
            return
        }
        
        var filtered = cities
        
        if !searchText.isEmpty {
            filtered = searchUseCase.execute(prefix: searchText)
        }
        
        if showFavoritesOnly {
            filtered = favoritesUseCase.filterFavorites(cities: filtered)
        }
        
        filteredCities = filtered
        itemsToShow = min(100, filtered.count)
    }
    
    // MARK: - Pagination
    
    func loadMoreItemsIfNeeded(for city: City) {
        guard let index = filteredCities.firstIndex(where: { $0.id == city.id }) else {
            return
        }
        
        let isApproachingEnd = index >= itemsToShow - 10
        let hasMoreItemsToShow = itemsToShow < filteredCities.count
        
        if isApproachingEnd && hasMoreItemsToShow {
            itemsToShow = min(itemsToShow + batchSize, filteredCities.count)
        }
    }
    
    // MARK: - User Actions
    
    func toggleFavorite(for city: City) {
        favoritesUseCase.toggleFavorite(cityId: city.id)
    }

    
    func identityFor(_ city: City) -> CityIdentity {
        CityIdentity(city: city, isFavorite: isFavorite(city))
    }
    
    func isFavorite(_ city: City) -> Bool {
        favoritesUseCase.isFavorite(cityId: city.id)
    }
    
    func selectCity(_ city: City?) {
        selectedCity = city
    }
}
