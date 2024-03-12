//
//  Scores.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 7/3/24.
//

import Foundation

struct ScoreDTO: Codable {
	let id: Int
	let title: String
	let composer: String
	let year: Int
	let length: Double
	let cover: String
	let tracks: [String]
	
	var toScore: Score {
		Score(id: id, title: title, composer: composer, year: year, length: length, cover: cover, tracks: tracks, favorited: false)
	}
}

// Este modelo es en base a los datos del json, lo que sería el modelo DTO
// Para guardar los favoritos, el DTO que viene del json sigue tal cual pero creamos otro struct para la capa de visualización al que añadimos la propiedad de favorito
// Y en el DTO creamos una propiedad calculada a modo de init para convertir de uno a otro
// Al hacer esto hay que modificar el interactor para que la función getScores haga decode al DTO, y luego transformamos al de visualización con .map


struct Score: Codable {
	let id: Int
	let title: String
	let composer: String
	let year: Int
	let length: Double
	let cover: String
	let tracks: [String]
	var favorited: Bool
}
