//
//  ContentView.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import SwiftUI

struct MainView: View {
    
    private let searchUseCase: SearchCitiesUseCase
    private let favoritesUseCase: FavoritesUseCase
    
    init(searchUseCase: SearchCitiesUseCase, favoritesUseCase: FavoritesUseCase) {
        self.searchUseCase = searchUseCase
        self.favoritesUseCase = favoritesUseCase
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}
