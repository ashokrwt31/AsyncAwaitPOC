//
//  ARMovieReview.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 04/10/22.
//

import Foundation

struct ARMovieReview: Codable {
    let results: [ARReview]
}

struct ARReview: Identifiable, Equatable, Codable {
    let id: String
    let author: String
    let content: String
}
