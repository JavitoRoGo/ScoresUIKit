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
		return try getJSON(url: url, type: [ScoreDTO].self).map(\.toScorePreview)
	}
	
	func saveScores(_ scores: [Score]) throws {
		
	}
}

extension ScoreDTO {
	var toScorePreview: Score {
		Score(id: id, title: title, composer: composer, year: year, length: length, cover: cover, tracks: tracks, favorited: Bool.random())
	}
}
