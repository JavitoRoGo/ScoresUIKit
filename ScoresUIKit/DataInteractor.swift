//
//  DataInteractor.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 7/3/24.
//

import Foundation

// Protocolo que obliga a tener la función de carga de los datos, que al implementarla podrá cargar datos del json de producción o del json de test
protocol DataInteractor {
	func getScores() throws -> [Score]
}

// Persistencia: lo llamamos interactor por seguir un poco la nomenclatura de la arquitectura de Clean Architecture
struct ScoreInteractor: DataInteractor, JSONLoader {
	// Patrón singleton para facilidad de acceso
	static let shared = ScoreInteractor()
	
	private init() {}
	
	// Implementación de la función de carga que viene del protocolo
	func getScores() throws -> [Score] {
		guard let url = Bundle.main.url(forResource: "scoresdata", withExtension: "json") else { return [] }
		return try getJSON(url: url, type: [Score].self)
	}
	
	// También se conforma al protocolo de JSONLoader, pero la función está ya implementada en la extensión
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
