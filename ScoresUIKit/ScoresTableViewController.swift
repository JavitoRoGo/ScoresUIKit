//
//  ScoresTableViewController.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 7/3/24.
//

import UIKit

// Al heredar de UITableViewController ya está conformado a DataSource y Delegate, es decir, ya incorpora los métodos del dataSource y del delegado; por lo que nosotros no vamos a implementar esos métodos, sino a sobrecargar los que ya están incorporados
// O sea, no vamos a conformar a DataSource y Delegate (que sí tendríamos que implementar sus métodos para poder conformarnos a ellos), sino que vamos a heredar de una clase que ya se conforma a esos protocolos, y por tanto ya incluye sus métodos, así que los vamos a sobrecargar con nuestra propia funcionalidad

final class ScoresTableViewController: UITableViewController {
	
	// Propiedad con la lógica para traer los datos y trabajar con ellos
	let logic = ScoreLogic.shared
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations: que la celda siga seleccionada al volver del detalle
		self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		self.navigationItem.rightBarButtonItem = self.editButtonItem
	}
	
	// MARK: - Table view data source
	
	// Si las secciones son 1, podemos borrar numberOfSections porque la clase padre ya devuelve ese 1 como total de secciones en la tabla
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		logic.scores.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// esta función es llamada tantas veces como celdas se muestren al usuario, y cada vez que una celda va a entrar en la vista
		let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
		// la tabla no tiene porqué saber cómo se obtiene el dato, esta lógica tiene que estar en la lógica de negocio de los datos. No obtenemos el dato aquí, sino con la función getScore
		let score = logic.getScore(indexPath: indexPath)
		
		var content = UIListContentConfiguration.subtitleCell()
		content.text = score.title
		content.secondaryText = score.composer
		content.image = UIImage(named: score.cover)
		cell.contentConfiguration = content
		
		return cell
	}
	
	// Override to support conditional editing of the table view.
	// La función pregunta para cada indexPath si puede editar la fila. Si devolvemos true tal cual, pues se podrán editar todas
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// hay que borrar el dato de la lógica por separado
			logic.removeScoreFrom(indexPath: indexPath)
			// Delete the row from the data source: esto borra la fila pero no el dato de la lógica
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		logic.moveScore(fromIndexPath, to: to)
	}
	
	// Override to support conditional rearranging of the table view.
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		// Return false if you do not want the item to be re-orderable.
		return true
	}
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Al pulsar la celda se activa el segue, y se ejecuta esta función de preparación
		guard let selected = tableView.indexPathForSelectedRow,
			  let destination = segue.destination as? ScoreDetailTableViewController else { return }
		destination.selectedScore = logic.getScore(indexPath: selected)
//		destination.movieTitle.text = "aslkdjfasjf" esto cuelga la app, porque en este momento el text todavía no existe, se crea al crear la vista. Por eso los datos se inyectan con la variable opcional en el controlador del detalle
	}
}
