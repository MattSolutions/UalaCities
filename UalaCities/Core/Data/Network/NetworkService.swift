//
//  NetworkService.swift
//  UalaCities
//
//  Created by MATIAS BATTITI on 14/05/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

/// Service for handling network requests
protocol NetworkService {
    /// Fetches and decodes data from a URL
    /// - Parameter url: The URL to fetch from
    /// - Returns: Decoded object of the specified type
    func fetchData<T: Decodable>(from url: URL) async throws -> T
}

/// Default implementation
class DefaultNetworkService: NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(from url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch let networkError as NetworkError {
            throw networkError
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingFailed(decodingError)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
