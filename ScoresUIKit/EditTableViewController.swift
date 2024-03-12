//
//  EditTableViewController.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 11/3/24.
//

import UIKit

class EditTableViewController: UITableViewController {
	
	let logic = ScoreLogic.shared
	
	var selectedScore: Score?
	
	@IBOutlet weak var movieTitle: UITextField!
	@IBOutlet weak var composer: UILabel!
	@IBOutlet weak var year: UITextField!
	@IBOutlet weak var length: UITextField!
	@IBOutlet weak var boton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		movieTitle.text = selectedScore?.title
		composer.text = selectedScore?.composer
		year.text = "\(selectedScore?.year ?? 1900)"
		length.text = "\(selectedScore?.length ?? 0)"
		
		// Para cada compositor se crea una acción con el nombre del compositor, y como acción que asigne el nombre al label
		let actions = logic.composers.map { name in
			UIAction(title: name) { [self] _ in
				composer.text = name
			}
		}
		boton.menu = UIMenu(title: "Select composer", children: actions)
		boton.showsMenuAsPrimaryAction = true
	}
}
