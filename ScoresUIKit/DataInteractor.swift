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
	func saveScores(_ scores: [Score]) throws
}

// Persistencia: lo llamamos interactor por seguir un poco la nomenclatura de la arquitectura de Clean Architecture
struct ScoreInteractor: DataInteractor, JSONPersistance {
	// Patrón singleton para facilidad de acceso
	static let shared = ScoreInteractor()
	
	private init() {}
	
	// Implementación de la función de carga que viene del protocolo
	func getScores() throws -> [Score] {
		guard let url = Bundle.main.url(forResource: "scoresdata", withExtension: "json") else { return [] }
		let urlDoc = URL.documentsDirectory.appending(path: "scoresdata.json")
		// En este ejemplo no igualamos url a urlDoc en caso de existir el archivo porque tenemos dos struct de vuelta diferentes: con y sin DTO
		// Por eso lo que hacemos es devolver cada uno en función de si existe el archivo o no
		return if FileManager.default.fileExists(atPath: urlDoc.path()) {
			try getJSON(url: urlDoc, type: [Score].self)
		} else {
			// en este caso se carga el dto del json, y con map lo transformamos a Score
			try getJSON(url: url, type: [ScoreDTO].self).map(\.toScore)
		}
	}
	
	func saveScores(_ scores: [Score]) throws {
		try putJSON(file: "scoresdata.json", datas: scores)
	}
	
	// También se conforma al protocolo de JSONPersistance, pero la función está ya implementada en la extensión
}



protocol JSONPersistance {
	func getJSON<JSON>(url: URL, type: JSON.Type) throws -> JSON where JSON: Codable
	func putJSON<JSON>(file: String, datas: JSON) throws where JSON: Codable
}

extension JSONPersistance {
	func getJSON<JSON>(url: URL, type: JSON.Type) throws -> JSON where JSON: Codable {
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode(type, from: data)
	}
	
	func putJSON<JSON>(file: String, datas: JSON) throws where JSON: Codable {
		let url = URL.documentsDirectory.appending(path: file)
		let data = try JSONEncoder().encode(datas)
		try data.write(to: url, options: .atomic)
		
		// con json se trabaja con datos en bruto, cada vez que grabamos se guarda todo el json completo; es imposible controlar qué parte cambia
		// para gran cantidad de datos y guardar solo los que cambien, se trabaja con bases de datos
	}
}
