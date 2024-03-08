//
//  Scores.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 7/3/24.
//

import Foundation

struct Score: Codable {
	let id: Int
	let title: String
	let composer: String
	let year: Int
	let length: Double
	let cover: String
	let tracks: [String]
}
