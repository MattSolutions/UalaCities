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
    @State private var opacity = 0.5
    @State private var backgroundColor = Color(red: 0.35, green: 0.2, blue: 0.8)
    
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
                    backgroundColor
                        .ignoresSafeArea()
                    
                    Image("SplashBackground")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height + 100)
                        .ignoresSafeArea()
                }
            }
            .opacity(opacity)
            .transition(.opacity)
            .onAppear {
                Task {
                    async let _ = try? await container.citiesRepository.getAllCities()

                    withAnimation(.easeIn(duration: 0.8)) {
                        self.opacity = 1.0
                    }

                    try? await Task.sleep(for: .seconds(2.0))

                    withAnimation(.easeInOut(duration: 0.6)) {
                        self.backgroundColor = Color(.systemBackground)
                    }

                    try? await Task.sleep(for: .seconds(0.4))

                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
