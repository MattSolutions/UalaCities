//
//  CityDetailsView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI
import MapKit

struct CityDetailsView: View {
    @EnvironmentObject private var coordinator: CitiesCoordinator
    @StateObject private var viewModel: CityDetailsViewModel
    
    let city: City
    
    init(city: City, favoritesUseCase: FavoritesUseCase) {
        self.city = city
        _viewModel = StateObject(wrappedValue: CityDetailsViewModel(
            city: city,
            favoritesUseCase: favoritesUseCase
        ))
    }
    
    var body: some View {
        content
            .navigationTitle(city.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    favoriteButton
                }
            }
    }
    
    // MARK: - Content Builders
    
    @ViewBuilder
    private var content: some View {
        ScrollView {
            VStack(spacing: 20) {
                mapPreview
                cityInformationCard
                Spacer()
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var mapPreview: some View {
        let region = MKCoordinateRegion(
            center: city.coordinates.clLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        Map(position: .constant(.region(region))) {
            Annotation(city.name, coordinate: city.coordinates.clLocation) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        )
        .disabled(true)
    }
    
    @ViewBuilder
    private var cityInformationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("City Information")
                .font(.headline)
            
            Divider()
            
            ForEach(cityInformationRows, id: \.label) { row in
                cityInformationRow(label: row.label, value: row.value)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var cityInformationRows: [(label: String, value: String)] {
        [
            ("Name", city.name),
            ("Country", city.country),
            ("Coordinates", "Lat: \(String(format: "%.6f", city.coordinates.latitude)), Lon: \(String(format: "%.6f", city.coordinates.longitude))"),
            ("Favorite", viewModel.isFavorite ? "Yes" : "No")
        ]
    }
    
    private func cityInformationRow(label: String, value: String) -> some View {
        HStack {
            Text("\(label):")
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .foregroundColor(label == "Favorite" && viewModel.isFavorite ? .yellow : .primary)
            
            Spacer()
        }
    }
    
    private var favoriteButton: some View {
        Button {
            viewModel.toggleFavorite()
        } label: {
            Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
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
    var favorites: Set<Int> = [1]
    
    func isFavorite(cityId: Int) -> Bool {
        favorites.contains(cityId)
    }
    
    func toggleFavorite(cityId: Int) -> Bool {
        if favorites.contains(cityId) {
            favorites.remove(cityId)
            return false
        } else {
            favorites.insert(cityId)
            return true
        }
    }
    
    func filterFavorites(cities: [City]) -> [City] {
        cities.filter { favorites.contains($0.id) }
    }
}
