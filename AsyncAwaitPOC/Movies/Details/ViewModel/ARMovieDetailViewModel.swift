//
//  ARMovieDetailViewModel.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 04/10/22.
//

import Foundation

struct ARMovieDetailViewModel {
    
    // MARK: - Using Async Await
    func callMoviesCastAPIAsyncAwait<T: Codable>(_ modelType: T.Type, _ movie: ARMovie) async throws -> Result<T, Error>?  {
        
        let creditURL = checkURL(ARAPI.movieCredit, movie)
        guard let url = creditURL else {
            return .failure(ARNetworkError.invalidUrl)
        }
        
        do {
            return try await ARNetworkManager().executeRequestWithAsyncAwait(url: url, modelType)
        } catch {
            throw error
        }
    }
    
    func callMoviesReviewsAPIAsyncAwait<T: Codable>(_ modelType: T.Type, _ movie: ARMovie) async throws -> Result<T, Error>?  {
        
        let reviewURL = checkURL(ARAPI.movieReview, movie)
        guard let url = reviewURL else {
            return .failure(ARNetworkError.invalidUrl)
        }
        do {
            return try await ARNetworkManager().executeRequestWithAsyncAwait(url: url, modelType)
        } catch {
            throw error
        }
    }
}


extension ARMovieDetailViewModel {
    
    func checkURL(_ urlString: String?, _ movie: ARMovie) -> URL? {
        guard var movieDetailURL = urlString else {
            return nil
        }
        
        movieDetailURL.replace("movieId", with: movie.id.description)
        movieDetailURL.replace( "apiKey",  with: ARAPI.apiKey!)
        
        guard let url = URL(string: movieDetailURL) else {
            return nil
        }
        return url
    }
}
 
