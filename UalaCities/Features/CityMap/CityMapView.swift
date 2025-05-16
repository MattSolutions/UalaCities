//
//  CityMapView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI
import MapKit

struct CityMapView: View {

    // MARK: - Properties

    @EnvironmentObject private var coordinator: CitiesCoordinator
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    @Environment(\.dismiss) private var dismiss
    
    
    // MARK: - Body
    
    var body: some View {
        Map(position: $position) {
            if let city = coordinator.selectedCity {
                Annotation(city.name, coordinate: city.coordinates.clLocation) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea(edges: [.horizontal, .bottom])
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    coordinator.clearNavigationAndSelection()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.blue)
                        .contentShape(Rectangle())
                        .padding(8)
                }
            }
            
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
        .onAppear {
            updateMapPosition()
        }
        .onReceive(coordinator.$mapRegion) { newRegion in
            position = .region(newRegion)
        }
        .onReceive(coordinator.$selectedCity) { _ in
            updateMapPosition()
        }
    }
    
    // MARK: - Actions
    
    private func updateMapPosition() {
        position = .region(coordinator.mapRegion)
    }
}
