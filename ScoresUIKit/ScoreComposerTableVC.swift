//
//  ScoreComposerTableVC.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 13/3/24.
//

import UIKit

class ScoreComposerTableVC: UITableViewController {
	let logic = ScoreLogic.shared
	
	var composer: String?
	
	lazy var dataSource: UITableViewDiffableDataSource<Int, Score> = {
		UITableViewDiffableDataSource<Int, Score>(tableView: tableView) { tableView, indexPath, score in
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
		tableView.dataSource = dataSource
		
		NotificationCenter.default.addObserver(forName: .composerSelected, object: nil, queue: .main) { [self] notification in
			guard let composer = notification.object as? String else { return }
			self.composer = composer
			loadDataComposers()
			Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [self] _ in
				NotificationCenter.default.post(name: .scoreSelected, object: dataSource.snapshot().itemIdentifiers[0])
			}
		}
		
		// Para que aparezcan los datos del primero al cargar la app y que el detalle no aparezca en blanco
		// Pero hay que darle un pequeño retraso para que cargue viewDidLoad de la vista de edit
		composer = logic.composers[0]
		loadDataComposers()
		Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [self] _ in
			NotificationCenter.default.post(name: .scoreSelected, object: dataSource.snapshot().itemIdentifiers[0])
		}
	}
	
	func loadDataComposers() {
		guard let composer else { return }
		navigationItem.title = composer
		let scores = logic.getScoresFromComposer(composer)
		var snapshot = NSDiffableDataSourceSnapshot<Int, Score>()
		snapshot.appendSections([1])
		snapshot.appendItems(scores, toSection: 1)
		dataSource.apply(snapshot, animatingDifferences: false)
	}
	
	// notification para las 3 columnas
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let selected = dataSource.itemIdentifier(for: indexPath) else { return }
		NotificationCenter.default.post(name: .scoreSelected, object: selected)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: .composerSelected, object: nil)
	}
}
