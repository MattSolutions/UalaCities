//
//  CityRow.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI

/// Reusable row component for displaying city information in lists
struct CityRow: View {
    // MARK: - Properties
    
    let city: City
    let isFavorite: Bool
    let isSelected: Bool
    let onToggleFavorite: () -> Void
    let onShowDetails: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            cityInfo
            Spacer()
            buttonControls
        }
        .padding(.vertical, 4)
        .background(isSelected ? Color.gray.opacity(0.1) : Color.clear)
    }
    
    // MARK: - UI Components
    
    private var cityInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(city.name), \(city.country)")
                .font(.headline)
            
            Text("Lat: \(String(format: "%.6f", city.coordinates.latitude)), Lon: \(String(format: "%.6f", city.coordinates.longitude))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var buttonControls: some View {
        HStack(spacing: 12) {
            favoriteButton
            detailsButton
        }
    }
    
    private var favoriteButton: some View {
        Button {
            onToggleFavorite()
        } label: {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundColor(isFavorite ? .yellow : .gray)
        }
        .buttonStyle(.plain)
    }
    
    private var detailsButton: some View {
        Button {
            onShowDetails()
        } label: {
            Image(systemName: "info.circle")
                .foregroundColor(.blue)
        }
        .buttonStyle(.plain)
    }
}
// MARK: - Preview Provider
#Preview(traits: .sizeThatFitsLayout) {
    CityRow(
        city: City(
            id: 1,
            name: "New York",
            country: "US",
            coordinates: Coordinate(latitude: 40.7128, longitude: -74.0060)
        ),
        isFavorite: true,
        isSelected: false,
        onToggleFavorite: {},
        onShowDetails: {}
    )
    .padding()
}
