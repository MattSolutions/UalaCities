//
//  CityMapView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI
import MapKit

struct CityMapView: View {
    @EnvironmentObject private var coordinator: CitiesCoordinator
    @StateObject private var viewModel: CityMapViewModel
    @State private var position: MapCameraPosition
    
    init() {
        _viewModel = StateObject(wrappedValue: CityMapViewModel())
        _position = State(initialValue: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )))
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Map(position: $position) {
                ForEach(viewModel.mapPins) { city in
                    Annotation(city.name, coordinate: city.coordinates.clLocation) {
                        VStack(spacing: 0) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 8, height: 8)
                                )
                        }
                    }
                }
            }
            .mapStyle(.standard)
            .edgesIgnoringSafeArea(.all)
            
            Button {
                coordinator.backToList()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .padding(8)
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
                .shadow(radius: 2)
            }
            .padding()
        }
        .onAppear {
            viewModel.updateMapPin(coordinator.selectedCity)
            updateMapPosition()
        }
        .onChange(of: coordinator.selectedCity) {
            viewModel.updateMapPin(coordinator.selectedCity)
        }
        .onReceive(coordinator.$mapRegion) { newRegion in
            position = .region(newRegion)
        }
    }
    
    private func updateMapPosition() {
        position = .region(coordinator.mapRegion)
    }
}
