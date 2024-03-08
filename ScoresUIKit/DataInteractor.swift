//
//  DataInteractor.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 7/3/24.
//

import Foundation

protocol DataInteractor {
	func getScores() throws -> [Score]
}

struct ScoreInteractor: DataInteractor, JSONLoader {
	static let shared = ScoreInteractor()
	
	private init() {}
	
	func getScores() throws -> [Score] {
		guard let url = Bundle.main.url(forResource: "scoresdata", withExtension: "json") else { return [] }
		return try getJSON(url: url, type: [Score].self)
	}
}



protocol JSONLoader {
	func getJSON<JSON>(url: URL, type: JSON.Type) throws -> JSON where JSON: Codable
}

extension JSONLoader {
	func getJSON<JSON>(url: URL, type: JSON.Type) throws -> JSON where JSON: Codable {
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode(type, from: data)
	}
}
