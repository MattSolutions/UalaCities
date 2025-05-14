//
//  PrefixTrie.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

/// Trie data structure optimized for fast prefix searching
class PrefixTrie<T> {
    private class TrieNode {
        var items: [T] = []
        var children: [Character: TrieNode] = [:]
    }
    
    private let root = TrieNode()
    
    /// Insert an item with the given key
    /// - Parameters:
    ///   - item: The item to insert
    ///   - key: The key to index this item under
    func insert(_ item: T, withKey key: String) {
        var current = root
        
        for char in key {
            if current.children[char] == nil {
                current.children[char] = TrieNode()
            }
            current = current.children[char]!
            current.items.append(item)
        }
    }
    
    /// Search for items with the given prefix
    /// - Parameter prefix: The prefix to search for
    /// - Returns: Array of items that match the prefix
    func search(prefix: String) -> [T] {
        var current = root
        
        for char in prefix {
            guard let next = current.children[char] else {
                return []
            }
            current = next
        }
        
        return current.items
    }
}
