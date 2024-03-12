//
//  DataPreview.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 7/3/24.
//

import Foundation

struct ScoreInteractorTest: DataInteractor, JSONPersistance {
	func getScores() throws -> [Score] {
		guard let url = Bundle.main.url(forResource: "scoresdatatest", withExtension: "json") else { return [] }
		return try getJSON(url: url, type: [ScoreDTO].self).map(\.toScore)
	}
	
	func saveScores(_ scores: [Score]) throws {
		
	}
}
