//
//  CustomTableViewController.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 11/3/24.
//

import UIKit

final class CustomTableViewController: UITableViewController {
	let logic = ScoreLogic.shared
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.clearsSelectionOnViewWillAppear = false
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		logic.scores.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath) as? CustomTableViewCell else {
			return UITableViewCell()
		}
		let score = logic.getScore(indexPath: indexPath)
		
		cell.scoreTitle.text = score.title
		cell.composer.text = score.composer
		cell.length.text = "\(score.length) min."
		cell.cover.image = UIImage(named: score.cover)
		
		return cell
	}
	
	// Más cosas que podemos hacer con los delegados: swipe actions
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let score = logic.getScore(indexPath: indexPath)
		let fav = logic.isFavorited(score: score)
		// Tenemos que crear una acción contextual
		let action = UIContextualAction(style: .normal, title: "Favorited") { [self] _, _, result in
			// result es un closure que escapa, pero no hace falta marcar weak porque no hay fuga, porque swipeAction deja de existir si no existe la tabla
			logic.toggleFavorite(score: score)
			result(true)
			// indicamos si hemos podido hacer la acción
		}
		action.image = UIImage(systemName: fav ? "star.fill" : "star")
		action.backgroundColor = fav ? .green : .orange
		return UISwipeActionsConfiguration(actions: [action])
	}
	
	
	// Esta es otra forma de hacer la navegación a la pantalla de detalle, que además la podemos reutilizar para llegar a ella desde dos tableView diferentes
	// Esta opción de navegación es más nueva y más eficiente que la otra
	@IBSegueAction func selectScore(_ coder: NSCoder) -> EditTableViewController? {
		// este coder es un constructor genérico para una pantalla
		guard let selected = tableView.indexPathForSelectedRow else { return nil }
		let detail = EditTableViewController(coder: coder)
		detail?.selectedScore = logic.getScore(indexPath: selected)
		return detail
	}
	
	
	// Esta función está conectada con EditTableViewController, con su botón de Save. Y se ejecuta cuando se pulsa ese otro botón de esa otra pantalla
	// La idea es que pulsemos en Save y se haga dismiss, y a la vez se guarden los datos y se envíe una señal a la tabla para que actualice los cambios
	// Para implementarlo hay que crear esta función directamente en código sin enlazar a nada, y en el storyboard conectar el botón de la otra pantalla que la ejecutará a su salida
	@IBAction func back(segue: UIStoryboardSegue) {
		guard let edit = segue.source as? EditTableViewController else { return }
		guard let selectedScore = edit.selectedScore,
			  let title = edit.movieTitle.text,
			  let composer = edit.composer.text,
			  let yearS = edit.year.text, let year = Int(yearS),
			  let lengthS = edit.length.text, let length = Double(lengthS),
			let indexPath = logic.getScoreIndexPath(score: selectedScore) else { return }
		
		let updatedScore = Score(id: selectedScore.id, title: title, composer: composer, year: year, length: length, cover: selectedScore.cover, tracks: selectedScore.tracks, favorited: selectedScore.favorited)
		
		logic.updateScore(updatedScore)
		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
}
