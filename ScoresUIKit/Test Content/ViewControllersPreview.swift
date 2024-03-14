//
//  ViewControllersPreview.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 13/3/24.
//

import UIKit

extension FavCollectionViewController {
	static var preview: UINavigationController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "favoritesView") as! FavCollectionViewController
		vc.logic = ScoreLogic(interactor: ScoreInteractorTest())
		let navigation = UINavigationController(rootViewController: vc)
		return navigation
		// creamos y devolvemos un navigation controller para que la preview haga bien la navegación
	}
}
