//
//  UalaCitiesApp.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import SwiftUI

@main
struct UalaCitiesApp: App {
    private let container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView(container: container)
        }
    }
}
