//
//  CustomCollectionViewCell.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 12/3/24.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cover: CustomImage!
	
	override func prepareForReuse() {
		cover.image = nil
	}
}
