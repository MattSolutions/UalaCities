//
//  CityDetailsView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI
import Combine
import MapKit

struct CityDetailsView: View {

    // MARK: - Properties

    @EnvironmentObject private var coordinator: CitiesCoordinator
    @StateObject private var viewModel: CityDetailsViewModel
    
    let city: City
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: city.coordinates.clLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
    
    // MARK: - Initialization

    init(city: City, favoritesUseCase: FavoritesUseCase) {
        self.city = city
        _viewModel = StateObject(wrappedValue: CityDetailsViewModel(
            city: city,
            favoritesUseCase: favoritesUseCase
        ))
    }
    
    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundView
            
            contentView
        }
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButton
            }
        }
        .toolbarBackground(Color.ualaBrand, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .foregroundStyle(.white)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isFavorite)
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
    
    private var contentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                mapPreview
                cityInformationCard
            }
            .padding()
        }
    }
    
    private var backButton: some View {
        Button {
            coordinator.clearNavigationAndSelection()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .contentShape(Rectangle())
                .padding(8)
        }
    }
    
    private var mapPreview: some View {
        Map(position: .constant(.region(region))) {
            Annotation(city.name, coordinate: city.coordinates.clLocation) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .disabled(true)
    }
    
    private var cityInformationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("City Information")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            ForEach(cityInformationRows, id: \.label) { row in
                cityInformationRow(label: row.label, value: row.value)
            }
        }
        .padding()
        .background(Color.ualaBorder)
        .cornerRadius(12)
    }
    
    private var cityInformationRows: [(label: String, value: String)] {
        [
            ("Name", city.name),
            ("Country", city.country),
            ("Coordinates", "Lat: \(String(format: "%.6f", city.coordinates.latitude)), Lon: \(String(format: "%.6f", city.coordinates.longitude))")
        ]
    }
    
    private func cityInformationRow(label: String, value: String) -> some View {
        HStack {
            Text("\(label):")
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 110, alignment: .leading)
            
            Text(value)
                .foregroundColor(.white)
                .fontWeight(.medium)
            
            Spacer()
        }
    }
    
    private var favoriteButton: some View {
        Button {
            viewModel.toggleFavorite()
        } label: {
            Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                .foregroundColor(viewModel.isFavorite ? Color.yellow : .white.opacity(0.5))
                .scaleEffect(viewModel.isFavorite ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isFavorite)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CityDetailsView(
            city: City(
                id: 1,
                name: "New York",
                country: "US",
                coordinates: Coordinate(latitude: 40.7128, longitude: -74.0060)
            ),
            favoritesUseCase: PreviewFavoritesUseCase()
        )
    }
}

private class PreviewFavoritesUseCase: FavoritesUseCase {
    private let favoritesSubject = PassthroughSubject<Void, Never>()
    
    var favoritesChanged: AnyPublisher<Void, Never> {
        favoritesSubject.eraseToAnyPublisher()
    }
    
    var favorites: Set<Int> = [1]
    
    func isFavorite(cityId: Int) -> Bool {
        favorites.contains(cityId)
    }
    
    func toggleFavorite(cityId: Int) -> Bool {
        let wasAdded: Bool
        if favorites.contains(cityId) {
            favorites.remove(cityId)
            wasAdded = false
        } else {
            favorites.insert(cityId)
            wasAdded = true
        }
        
        favoritesSubject.send()
        
        return wasAdded
    }
    
    func filterFavorites(cities: [City]) -> [City] {
        cities.filter { favorites.contains($0.id) }
    }
}
