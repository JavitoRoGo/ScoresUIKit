//
//  CustomImage.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 11/3/24.
//

import UIKit

class CustomImage: UIImageView {
	override func awakeFromNib() {
		// si queremos los bordes de la imagen redondeados y personalizar la imagen
//		layer.shadowOffset = CGSize(width: 0, height: 5)
//		layer.shadowOpacity = 0.4
//		layer.shadowRadius = 5.0
//		layer.shadowColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
		clipsToBounds = true
		layer.cornerRadius = 10.0
	}
}
