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
        mapContent
            .modifier(NavigationBarModifier(backAction: {
                coordinator.clearNavigationAndSelection()
            }))
            .modifier(MapEventsModifier(
                updatePositionAction: updateMapPosition,
                mapRegionPublisher: coordinator.$mapRegion,
                selectedCityPublisher: coordinator.$selectedCity
            ))
    }
    
    // MARK: - Content Components
    
    private var mapContent: some View {
        mapView
            .background(Color.ualaBrand)
            .ignoresSafeArea(edges: [.horizontal, .bottom])
    }
    
    private var mapView: some View {
        Map(position: $position) {
            if let city = coordinator.selectedCity {
                Annotation(city.name, coordinate: city.coordinates.clLocation) {
                    mapPin
                }
            }
        }
        .mapStyle(.standard)
    }
    
    private var mapPin: some View {
        Image(systemName: "mappin.circle.fill")
            .font(.title)
            .foregroundColor(Color.ualaAccent)
    }
    
    // MARK: - Actions
    
    private func updateMapPosition() {
        position = .region(coordinator.mapRegion)
    }
}

// MARK: - View Modifiers

struct NavigationBarModifier: ViewModifier {
    let backAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: backAction) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .contentShape(Rectangle())
                            .padding(8)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    EmptyView()
                }
            }
            .toolbarBackground(Color.ualaBrand, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .foregroundStyle(.white)
    }
}

struct MapEventsModifier: ViewModifier {
    let updatePositionAction: () -> Void
    let mapRegionPublisher: Published<MKCoordinateRegion>.Publisher
    let selectedCityPublisher: Published<City?>.Publisher
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                updatePositionAction()
            }
            .onReceive(mapRegionPublisher) { _ in
                updatePositionAction()
            }
            .onReceive(selectedCityPublisher) { _ in
                updatePositionAction()
            }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        CityMapView()
            .environmentObject(CitiesCoordinator())
    }
}
