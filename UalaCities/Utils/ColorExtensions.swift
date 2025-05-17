//
//  ColorExtensions.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 17/05/2025.
//

import SwiftUI

extension Color {
    // MARK: - Brand Colors
    
    /// Primary brand color
    static let ualaBrand = Color(red: 0.0, green: 0.22, blue: 0.67)
    
    /// Secondary accent color
    static let ualaAccent = Color(red: 0.2, green: 0.5, blue: 0.95)
    
    // MARK: - UI Colors
    
    /// Primary text color (white)
    static let ualaPrimaryText = Color.white
    
    /// Secondary text color
    static let ualaSecondaryText = Color.white.opacity(0.7)
    
    /// Semi-transparent overlay for containers
    static let ualaOverlay = Color.black.opacity(0.2)
    
    /// Border color for elements
    static let ualaBorder = Color.ualaAccent.opacity(0.5)
    
    // MARK: - Gradients
    
    /// Gradient effect for backgrounds
    static let ualaBrandGradient = LinearGradient(
        colors: [
            Color.blue.opacity(0.1),
            Color.ualaBrand.opacity(0.1)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
