//
//  ARMovie.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 02/10/22.
//

import Foundation
import UIKit


struct ARMovieResponse: Codable {
    let results: [ARMovie]
}

struct ARMovie: Codable, Identifiable {
    var id: Int
    let title: String
    let overview: String
    let posterPath: String
    var posterURL: URL? {
        if let url =  URL(string: "https://image.tmdb.org/t/p/w154/\(posterPath)") {
            //URL(string: "https://image.tmdb.org/t/p/w154/5GA3vV1aWWHTSDO5eno8V5zDo8.jpg") {
            //URL(string: "https://image.tmdb.org/t/p/w154/\(posterPath)")
            //URL(string: "http://vi.placeholder.com/80x80")/
            return url
        }
        return nil
    }
}


extension ARMovie {
    
    // MARK: - Async properties
    
    var posterMovieImage: UIImage {
        get async {
            let ( data, _) = try! await URLSession.shared.data(from: self.posterURL!)
            return UIImage(data: data)!
        }
    }
    
    // MARK: -  async properties that throw
    
    var posterImage: UIImage? {
        get async throws {
            guard let postUrl = self.posterURL else {
                return nil
            }
//            return try await getProcessedImage(postUrl)
            do {
                let ( data, _) = try await URLSession.shared.data(from: postUrl)
                return UIImage(data: data)
            } catch {
                throw error
            }
        }
    }
    
    func getProcessedImage(_ url: URL) async throws -> UIImage? {
        let ( data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data) ?? nil
      }
}
