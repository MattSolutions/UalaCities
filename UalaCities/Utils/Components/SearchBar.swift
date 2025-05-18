//
//  SearchBar.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI

struct SearchBar: View {
    // MARK: - Properties
    
    @Binding var searchText: String
    let placeholder: String = "Search for a city..."
    var onClear: (() -> Void)?
    
    // MARK: - Body
    
    var body: some View {
        searchBarContainer
    }
    
    // MARK: - UI Components
    
    private var searchBarContainer: some View {
        HStack {
            searchIcon
            customTextField
            clearButton
        }
        .padding(10)
        .background(Color.ualaOverlay)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.ualaBorder, lineWidth: 1)
        )
        .cornerRadius(10)
    }
    
    private var searchIcon: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.white)
    }
    
    private var customTextField: some View {
        TextField("", text: $searchText, prompt: Text(placeholder)
            .foregroundColor(.ualaSecondaryText)
            .fontWeight(.regular)
        )
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        .foregroundColor(.white)
        .fontWeight(.semibold)
        .tint(.white)
        .background(Color.clear)
    }
    
    private var clearButton: some View {
        Button {
            searchText = ""
            onClear?()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white)
        }
        .opacity(searchText.isEmpty ? 0 : 1)
        .animation(.easeInOut(duration: 0.2), value: searchText.isEmpty)
    }
}

// MARK: - Preview Provider
#Preview(traits: .sizeThatFitsLayout) {
    ZStack {
        Color.ualaBrand.ignoresSafeArea()
        
        VStack {
            SearchBar(searchText: .constant(""))
            SearchBar(searchText: .constant("New York"))
        }
        .padding()
    }
}
