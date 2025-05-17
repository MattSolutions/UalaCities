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
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .cornerRadius(10)
    }
    
    // MARK: - UI Components
    
    private var cityInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(city.name), \(city.country)")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Lat: \(String(format: "%.6f", city.coordinates.latitude)), Lon: \(String(format: "%.6f", city.coordinates.longitude))")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
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
                .foregroundColor(isFavorite ? .yellow : .white.opacity(0.5))
                .font(.system(size: 22))
        }
        .buttonStyle(.plain)
    }
    
    private var detailsButton: some View {
        Button {
            onShowDetails()
        } label: {
            Image(systemName: "info.circle")
                .foregroundColor(.white)
                .font(.system(size: 22))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview Provider
#Preview(traits: .sizeThatFitsLayout) {
    ZStack {
        Color.ualaBrand.ignoresSafeArea()
        
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
}
