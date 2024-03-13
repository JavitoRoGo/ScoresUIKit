//
//  FavCollectionViewController.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 12/3/24.
//

import UIKit

// Esto lo vamos a hacer también con diffable data source, pero sin secciones

final class FavCollectionViewController: UICollectionViewController {
	let logic = ScoreLogic.shared
	
	// Este dataSource se declara como lazy porque en su interior usa el propio collectionView, que es una propiedad de instancia que no estaría accesible hasta que se inicie
	lazy var dataSource: UICollectionViewDiffableDataSource<Int, Score> = {
		UICollectionViewDiffableDataSource<Int, Score>(collectionView: collectionView) { collectionView, indexPath, score in
			let item = collectionView.dequeueReusableCell(withReuseIdentifier: "zelda", for: indexPath) as? CustomCollectionViewCell
			item?.cover.image = UIImage(named: score.cover)
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
	
	// No olvidar borrar el observador cuando la clase deje de existir
	deinit {
		NotificationCenter.default.removeObserver(self, name: .favChanges, object: nil)
	}
}
