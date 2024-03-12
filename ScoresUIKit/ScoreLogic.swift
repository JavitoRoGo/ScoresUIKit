//
//  ScoreLogic.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 7/3/24.
//

import Foundation

// Clase con la lógica de negocio: buscar, borrar, mover, etc.
// Pero la carga está en el interactor, también el guardado (persistencia)
final class ScoreLogic {
	static let shared = ScoreLogic()
	
	// Propiedad del tipo del protocolo, para inyectar interactor de producción o test
	let interactor: DataInteractor
	
	var scores: [Score] {
		didSet {
			try? interactor.saveScores(scores)
		}
	}
	
	var composers: [String] {
		Set(scores.map(\.composer)).sorted()
	}
	
	// Aquí el init no es private para poder acceder a él e inyectar el interactor de test
	init(interactor: DataInteractor = ScoreInteractor.shared) {
		self.interactor = interactor
		self.scores = (try? interactor.getScores()) ?? []
	}
	
	func getScore(indexPath: IndexPath) -> Score {
		scores[indexPath.row]
	}
	
	func getScoreIndexPath(score: Score) -> IndexPath? {
		if let index = scores.firstIndex(where: { $0.id == score.id }) {
			IndexPath(row: index, section: 0)
		} else {
			nil
		}
	}
	
	func removeScore(indexPath: IndexPath) {
		scores.remove(at: indexPath.row)
	}
	
	func moveScore(_ indexPath: IndexPath, to: IndexPath) {
		scores.swapAt(indexPath.row, to.row)
	}
	
	func updateScore(_ score: Score) {
		if let index = scores.firstIndex(where: { $0.id == score.id }) {
			scores[index] = score
		}
	}
	
	func toggleFavorite(score: Score) {
		if let index = scores.firstIndex(where: { $0.id == score.id }) {
			scores[index].favorited.toggle()
		}
	}
	
	func isFavorited(score: Score) -> Bool {
		if let index = scores.firstIndex(where: { $0.id == score.id }) {
			scores[index].favorited
		} else {
			false
		}
	}
}
