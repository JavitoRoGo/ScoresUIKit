//
//  ScoreDetailTableViewController.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 7/3/24.
//

import UIKit

class ScoreDetailTableViewController: UITableViewController {
	
	let logic = ScoreLogic.shared
	
	@IBOutlet weak var movieTitle: UILabel!
	@IBOutlet weak var composer: UILabel!
	@IBOutlet weak var year: UILabel!
	@IBOutlet weak var length: UILabel!
	
	// esta variable es para recibir los datos del maestro. Los datos se inyectan aquí
	var selectedScore: Score?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		movieTitle.text = selectedScore?.title
		composer.text = selectedScore?.composer
		year.text = "\(selectedScore?.year ?? 1900)"
		length.text = "\(selectedScore?.length ?? 0)"
	}
}
