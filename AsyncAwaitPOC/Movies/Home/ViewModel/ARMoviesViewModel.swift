//
//  ARMoviesViewModel.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 02/10/22.
//

import Foundation

typealias MoviesCompletionClosure = ((ARMovieResponse?, Error?) -> Void)

struct ARMoviesViewModel {
    
    // MARK: - Using Async Await
    func callMoviesAPIAsyncAwait<T: Codable>(_ modelType: T.Type) async throws -> Result<T, Error>?  {
        guard let baseURL = ARAPI.baseURL, let apiKey = ARAPI.apiKey,
                let url =  URL(string: baseURL + apiKey) else {
            return .failure(ARNetworkError.invalidUrl)
        }
        print(url)
        do {
           return try await ARNetworkManager().executeRequestWithAsyncAwait(url: url, modelType)
        } catch {
            throw error
        }
    }
}


extension ARMoviesViewModel {
    
    // MARK: - Using Closure
    
    func callMoviesAPI(completion: @escaping MoviesCompletionClosure) {
        guard let baseURL = ARAPI.baseURL, let apiKey = ARAPI.apiKey,
                let url =  URL(string: baseURL + apiKey) else {
            completion(nil, ARNetworkError.invalidUrl)
            return
        }
        ARNetworkManager().executeRequest(url: url, completion: completion)
    }
}





/*
 
 let result = try await ARNetworkManager().executeRequestWithAsyncAwait(url: url, modelType)
 switch result {
 case .failure(let error): print(error)
 case .success(let items): print(items)
 case .none: print("None")
 }
 return result
 */
