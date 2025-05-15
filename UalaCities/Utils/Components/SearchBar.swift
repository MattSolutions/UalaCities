//
//  SearchBar.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 15/05/2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var placeholder: String = "Search"
    var onClear: (() -> Void)?
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $searchText)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    onClear?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Preview Provider
#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        SearchBar(searchText: .constant(""))
        SearchBar(searchText: .constant("New York"))
    }
    .padding()
}
