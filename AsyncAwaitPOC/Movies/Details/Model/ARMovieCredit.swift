//
//  ARMovieCredit.swift
//  AsyncAwaitPOC
//
//  Created by Ashok Rawat on 04/10/22.
//

import Foundation

struct ARMovieCredit: Codable {
    let cast: [ARMovieCast]
}

struct ARMovieCast: Identifiable, Equatable, Codable {
    let id: Int
    let name: String
    let character: String
}
