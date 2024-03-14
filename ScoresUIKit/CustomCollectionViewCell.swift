//
//  CustomCollectionViewCell.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 12/3/24.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cover: CustomImage!
	@IBOutlet weak var fondo: UIView!
	@IBOutlet weak var title: UILabel!
	
	override func awakeFromNib() {
		fondo.alpha = 0.7
		// si queremos usar los materiales que hay en SwiftUI:
		let material = UIBlurEffect(style: .systemUltraThinMaterial)
		let view = UIVisualEffectView(effect: material)
		view.frame = fondo.frame
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		fondo.addSubview(view)
	}
	
	override func prepareForReuse() {
		cover.image = nil
		title.text = nil
	}
}
