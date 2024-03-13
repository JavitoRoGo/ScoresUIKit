//
//  CustomTableViewCell.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 11/3/24.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
	// Esto es una subclase de UIView, y NO de UIViewController, por eso no hay viewDidLoad
	
	@IBOutlet weak var cover: CustomImage!
	@IBOutlet weak var scoreTitle: UILabel!
	@IBOutlet weak var composer: UILabel!
	@IBOutlet weak var length: UILabel!
	
	override func prepareForReuse() {
		// así optimizamos la limpieza de la celda para reutilizarla. No es necesario pero es una buena práctica
		cover.image = nil
		scoreTitle.text = nil
		composer.text = nil
		length.text = nil
	}
}
