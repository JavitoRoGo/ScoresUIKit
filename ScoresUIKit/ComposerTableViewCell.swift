//
//  ComposerTableViewCell.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 13/3/24.
//

import UIKit

class ComposerTableViewCell: UITableViewCell {
	@IBOutlet weak var composer: UIImageView!
	@IBOutlet weak var name: UILabel!
	
	override func awakeFromNib() {
		composer.layer.cornerRadius = composer.frame.size.width / 2
	}
	
	override func prepareForReuse() {
		composer.image = nil
		name.text = nil
	}
}
