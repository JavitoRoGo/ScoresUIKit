//
//  EditTableViewController.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 11/3/24.
//

import UIKit

final class EditTableDiffableViewController: UITableViewController, ScoreSelectionDelegate {
	
	let logic = ScoreLogic.shared
	
	var selectedScore: Score?
	
	@IBOutlet weak var movieTitle: UITextField!
	@IBOutlet weak var composer: UILabel!
	@IBOutlet weak var year: UITextField!
	@IBOutlet weak var length: UITextField!
	@IBOutlet weak var boton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initScoreData()
		connectDelegate()
		
		// Para cada compositor se crea una acción con el nombre del compositor, y como acción que asigne el nombre al label
		let actions = logic.composers.map { name in
			UIAction(title: name) { [self] _ in
				composer.text = name
			}
		}
		boton.menu = UIMenu(title: "Select composer", children: actions)
		boton.showsMenuAsPrimaryAction = true
	}
	
	func initScoreData() {
		movieTitle.text = selectedScore?.title
		composer.text = selectedScore?.composer
		year.text = "\(selectedScore?.year ?? 1900)"
		length.text = "\(selectedScore?.length ?? 0)"
	}
	
	// Para conectar maestro y detalle en iPad necesitamos la instancia real de DiffableTableViewController, no una instancia nueva
	// Es así de rollo para recuperar esta instancia, porque son varios controladores
	// Creo que son dos formas de hacerlo, por eso lo comentado
	func connectDelegate() {
//		guard let window = UIApplication.shared
//			.connectedScenes
//			.compactMap({ $0 as? UIWindowScene })
//			.flatMap(\.windows)
//			.first(where: { $0.isKeyWindow })?
//			.rootViewController as? UISplitViewController else { return }
		guard let navigation = splitViewController?.viewControllers.first as? UINavigationController,
			  let tableView = navigation.topViewController as? DiffableTableViewController else { return }
		
		tableView.delegate = self
		tableView.selectFirst()
		
		// esta función no se ejecuta en iPhone porque no existe splitViewController y sale por return, así que no se rompe nada
	}
	
	@IBAction func saveScore(_ sender: UIBarButtonItem) {
		guard let title = movieTitle.text,
			  let yearS = year.text,
			  let lengthS = length.text else { return }
		
		var mensaje = ""
		if title.isEmpty {
			mensaje += "Title cannot be empty.\n"
		}
		if let yearNum = Int(yearS) {
			if yearNum < 1900 || yearNum > 2050 {
				mensaje += "Year must be only numbers, from 1900 to 2050.\n"
			}
		} else {
			mensaje += "Year must be only numbers.\n"
		}
		if let lengthNum = Double(lengthS) {
			if lengthNum < 1 || lengthNum > 300 {
				mensaje += "Length must be between 1 and 300.\n"
			}
		} else {
			mensaje += "Length must be only numbers.\n"
		}
		
		if mensaje.isEmpty {
			// ahora conectamos el unwindsegue desde este ViewCotroller hacia su salida y le damos un nombre (en el storyboard), y lo ejecutamos aquí si todo ha ido bien
			performSegue(withIdentifier: "backToMaster", sender: nil)
		} else {
			showAlert(mensaje: String(mensaje.dropLast()))
		}
	}
	
	func showAlert(mensaje: String) {
		let alert = UIAlertController(title: "Validation Error", message: mensaje, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel))
		present(alert, animated: true)
	}
	
	
	// Conformamos a nuestro protocolo y ponemos la función, para navegar en el iPad
	func itemSelected(score: Score) {
		selectedScore = score
		initScoreData()
	}
}
