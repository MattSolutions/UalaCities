//
//  SplashScreenView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 16/05/2025.
//

import SwiftUI

struct SplashScreenView: View {
    // MARK: - Properties
    
    @State private var isActive = false
    private let container: DependencyContainer
    
    // MARK: - Initialization
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    // MARK: - Body
    
    var body: some View {
        if isActive {
            MainView(
                searchUseCase: container.searchCitiesUseCase,
                favoritesUseCase: container.favoritesUseCase
            )
        } else {
            GeometryReader { geo in
                ZStack {
                    Color(red: 0.35, green: 0.2, blue: 0.8)
                        .ignoresSafeArea()
                    
                    Image("SplashBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height + 100)
                        .ignoresSafeArea()
                }
            }
            .transition(.opacity)
            .onAppear {
                Task {
                    _ = try? await container.citiesRepository.getAllCities()
                    
                    try? await Task.sleep(for: .seconds(1.0))
                    
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
