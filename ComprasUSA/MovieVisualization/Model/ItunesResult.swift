//
//  ItunesResult.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 08/12/22.
//

import Foundation

struct ItunesResult: Decodable {
    let results: [MovieInfo]
}

struct MovieInfo: Decodable {
    let previewUrl: String
}
