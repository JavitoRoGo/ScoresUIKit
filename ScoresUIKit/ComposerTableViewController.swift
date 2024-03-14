//
//  ComposerTableViewController.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 13/3/24.
//

import UIKit

class ComposerTableViewController: UITableViewController {
	let logic = ScoreLogic.shared
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// aquí va un notificationcenter para seleccionar la primera linea
		NotificationCenter.default.post(name: .composerSelected, object: logic.composers[0])
		tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		logic.composers.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath) as? ComposerTableViewCell else {
			return UITableViewCell()
		}
		
		let composer = logic.composers[indexPath.row]
		cell.composer.image = UIImage(named: composer)
		cell.name.text = composer
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// enviamos a quien escuche la notificación y el composer
		NotificationCenter.default.post(name: .composerSelected, object: logic.composers[indexPath.row])
	}
}


// La navegación entre pantallas o tablas hay que hacerla con notificaciones porque en este tipo de storyboard de split view con 3 columnas, los segue no funcionan como los hemos usado hasta ahora para el iPhone
