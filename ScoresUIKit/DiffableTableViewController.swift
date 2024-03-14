//
//  DiffableTableViewController.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 12/3/24.
//

import UIKit

// Con las fuentes difusas no hay delegados, o se minimizan y se ponen en otro lugar
// Esto está a partir de iOS 13, pero casi nadie lo sabe o lo usa
// Se hace de forma totalmente diferente, basado en un diffable data source que usa dos genéricos: uno para los datos de las secciones y otro para los datos a representar en las rows
// El segundo genérico (nuestros datos) tiene que ser Hashable, para que sepa cuándo un dato ha cambiado y actualizar la tabla
// Esto cambia la forma de presentar la tabla; lo de la lógica y el interactor sigue igual. Ahora pasa a ser una tabla casi reactiva, mucho más fácil de manejar y actualizar
// Las fuentes difusas son mucho más eficientes que el uso de delegados para el dataSource

final class DiffableTableViewController: UITableViewController, UISearchResultsUpdating {
	let logic = ScoreLogic.shared
	
	var delegate: ScoreSelectionDelegate?
	
	// aquí cambiamos el tipo a la clase que nos hicimos, para tener la lógica fuera, más ordenada
	lazy var dataSource: ScoreDiffableDataSource = {
		ScoreDiffableDataSource(tableView: tableView) { tableView, indexPath, score in
			// echarle un ojo a la documentación de esta función para entender bien lo qué nos está devolviendo: la propia tabla, el indexPath y el dato
			// este closure de CellProvider nos entrega la tabla, el indexPath y el dato, y tenemos que devolver una celda
			// la celda que devolvemos es igual a como lo hacemos de forma "clásica", salvo por dos cosas: no tenemos que calcular el score porque ya nos lo entrega el closure; y no necesitamos el guard porque sí nos deja devolver una celda opcional
			let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath) as? CustomTableViewCell
			cell?.scoreTitle.text = score.title
			cell?.composer.text = score.composer
			cell?.length.text = "\(score.length) min."
			cell?.cover.image = UIImage(named: score.cover)
			return cell
		}
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Ya no hay delegados, los datos los cargamos aquí. ¡Y ya está, con dos líneas!
		tableView.dataSource = dataSource
		dataSource.apply(logic.getSnapshot)
		
		
		// barra de búsqueda, usando más delegados: UISearchResultUpdating
		let search = UISearchController(searchResultsController: nil)
		search.searchBar.placeholder = "Enter a score name"
		search.obscuresBackgroundDuringPresentation = false
		navigationItem.searchController = search
		navigationItem.searchController?.searchResultsUpdater = self
	}
	
	
	// esta función es para que el iPad muestre el detalle del primer elemento al iniciar la app, hasta que se pulse algo, y también aparece pulsada la fila
	func selectFirst() {
		let indexPath = IndexPath(row: 0, section: 0)
		guard let first = dataSource.itemIdentifier(for: indexPath) else { return }
		delegate?.itemSelected(score: first)
		tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
	}
	
	
	// aquí tenemos los delegados del tableViewDelegate (los del data source están en la clase a parte), por eso esta función de swipe va aquí
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		guard let score = dataSource.itemIdentifier(for: indexPath) else { return nil }
		let fav = logic.isFavorited(score: score)
		let action = UIContextualAction(style: .normal, title: "Favorited") { [self] _, _, result in
			logic.toggleFavorite(score: score)
			
			// insertamos el envío de una notificación para que la colección de favoritos se entere que cambió
			// en este swipe marcamos o desmarcamos los favoritos, y creamos un post que se emitirá con cada cambio de propiedad, y se escuchará en el controlador de los favoritos
			NotificationCenter.default.post(name: .favChanges, object: nil)
			
			result(true)
		}
		action.image = UIImage(systemName: fav ? "star.fill" : "star")
		action.backgroundColor = fav ? .green : .orange
		return UISwipeActionsConfiguration(actions: [action])
	}
	
	
	@IBSegueAction func goToDetail(_ coder: NSCoder) -> EditTableDiffableViewController? {
		guard let selected = tableView.indexPathForSelectedRow else { return nil }
		let detail = EditTableDiffableViewController(coder: coder)
		// ahora el dato no lo sacamos de la lógica, sino del dataSource
		detail?.selectedScore = dataSource.itemIdentifier(for: selected)
		return detail
	}
	
	@IBAction func backToMaster(_ segue: UIStoryboardSegue) {
		guard let edit = segue.source as? EditTableDiffableViewController else { return }
		guard let selectedScore = edit.selectedScore,
			  let title = edit.movieTitle.text,
			  let composer = edit.composer.text,
			  let yearS = edit.year.text, let year = Int(yearS),
			  let lengthS = edit.length.text, let length = Double(lengthS) else { return }
		
		let updatedScore = Score(id: selectedScore.id, title: title, composer: composer, year: year, length: length, cover: selectedScore.cover, tracks: selectedScore.tracks, favorited: selectedScore.favorited)
		
		logic.updateScore(updatedScore)
		// aquí no hace falta recuperar el indexPath, sino que se actualice una vez hecho el cambio y ya
		dataSource.apply(logic.getSnapshot, animatingDifferences: false) // esta opción es para que no haga una animación al recargar la fila
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let search = searchController.searchBar.text else { return }
		logic.search = search
		dataSource.apply(logic.getSnapshot)
	}
	
	
	// Añadimos este delegado para la navegación en iPad, para saber qué elemento se ha tocado y enviarlo a la pantalla de detalla. Aunque con un NotificationCenter sería más sencillo
	// También necesitamos un protocolo
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let score = dataSource.itemIdentifier(for: indexPath) else { return }
		delegate?.itemSelected(score: score)
		
		// esta función sí se ejecuta en iPhone al pulsar una fila, pero como delegate es nil pues sale por return y funciona
	}
}


protocol ScoreSelectionDelegate {
	func itemSelected(score: Score)
}
