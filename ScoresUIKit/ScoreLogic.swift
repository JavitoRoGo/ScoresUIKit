//
//  ScoreLogic.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 7/3/24.
//

import UIKit

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
	
	var search = ""
	
	var getSnapshot: NSDiffableDataSourceSnapshot<String, Score> {
		var snapshot = NSDiffableDataSourceSnapshot<String, Score>()
		// sección por compositor
		snapshot.appendSections(composers)
		// añadir datos por sección
		for composer in composers {
//			snapshot.appendItems(getScoresFromComposer(composer), toSection: composer)
			// cambiamos la línea anterior para poner la búsqueda
			if search.isEmpty {
				snapshot.appendItems(getScoresFromComposer(composer), toSection: composer)
			} else {
				let scores = getScoresFromComposer(composer).filter { score in
					score.title.range(of: search, options: [.caseInsensitive, .diacriticInsensitive]) != nil
				}
				if scores.count > 0 {
					snapshot.appendItems(scores, toSection: composer)
				} else {
					// si no encuentra alguno, que borre la sección del compositor para que no aparezca sin datos
					snapshot.deleteSections([composer])
				}
			}
		}
		return snapshot
	}
	
	var getFavSnapShot: NSDiffableDataSourceSnapshot<Int, Score> {
		var snapshot = NSDiffableDataSourceSnapshot<Int, Score>()
		snapshot.appendSections([1])
		snapshot.appendItems(scores.filter({ $0.favorited }), toSection: 1)
		return snapshot
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
	
	func removeScoreFrom(indexPath: IndexPath) {
		scores.remove(at: indexPath.row)
	}
	
	func removeScore(_ score: Score) {
		scores.removeAll { s in
			s == score
		}
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
	
	func getScoresFromComposer(_ composer: String) -> [Score] {
		scores.filter {
			$0.composer == composer
		}
	}
}
