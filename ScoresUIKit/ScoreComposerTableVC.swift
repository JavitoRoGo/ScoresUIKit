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
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: .composerSelected, object: nil)
	}
}
