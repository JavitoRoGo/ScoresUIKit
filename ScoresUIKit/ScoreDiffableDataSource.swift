//
//  ScoreDiffableDataSource.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 12/3/24.
//

import UIKit

final class ScoreDiffableDataSource: UITableViewDiffableDataSource<String, Score> {
	let logic = ScoreLogic.shared
	
	// creamos esta clase basada en el constructor del data source para poder acceder a todos los datos y poner nombre a las secciones
	// porque aquí tenemos el snapshot y todos los delegados, pero solo los delegados del data source
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		snapshot().sectionIdentifiers[section]
	}
	
	// y como tenemos los delegados, pues podemos borrar también
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		true
	}
	
	// copiar la función de borrado que no la carga
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// no necesitamos el indexpath para borrar, porque ahora sí tenemos secciones, así que mejor borrar el score directamente
			guard let score = itemIdentifier(for: indexPath) else { return }
			logic.removeScore(score)
			apply(logic.getSnapshot)
		}
	}
}
