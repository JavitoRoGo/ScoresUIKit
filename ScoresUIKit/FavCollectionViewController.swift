//
//  FavCollectionViewController.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 12/3/24.
//

import UIKit

// Esto lo vamos a hacer también con diffable data source, pero sin secciones

final class FavCollectionViewController: UICollectionViewController {
	var logic = ScoreLogic.shared
	
	// Este dataSource se declara como lazy porque en su interior usa el propio collectionView, que es una propiedad de instancia que no estaría accesible hasta que se inicie
	lazy var dataSource: UICollectionViewDiffableDataSource<Int, Score> = {
		UICollectionViewDiffableDataSource<Int, Score>(collectionView: collectionView) { collectionView, indexPath, score in
			let item = collectionView.dequeueReusableCell(withReuseIdentifier: "zelda", for: indexPath) as? CustomCollectionViewCell
			item?.cover.image = UIImage(named: score.cover)
			item?.title.text = score.title
			return item
		}
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.dataSource = dataSource
		dataSource.apply(logic.getFavSnapShot)
		
		// aquí ponemos un receptor de notificaciones para escuchar el post que se lanza al actualizar los favoritos
		NotificationCenter.default.addObserver(forName: .favChanges, object: nil, queue: .main) { [self] _ in
			dataSource.apply(logic.getFavSnapShot)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let selected = collectionView.indexPathsForSelectedItems?.first,
			  let destination = segue.destination as? ScoreDetailTableViewController else { return }
		destination.selectedScore = dataSource.itemIdentifier(for: selected)
	}
	
	// No olvidar borrar el observador cuando la clase deje de existir
	deinit {
		NotificationCenter.default.removeObserver(self, name: .favChanges, object: nil)
	}
}


// En teoría, se pueden crear previews aquí

#Preview {
	FavCollectionViewController.preview
}
