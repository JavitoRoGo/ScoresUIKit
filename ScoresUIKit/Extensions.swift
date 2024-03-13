//
//  Extensions.swift
//  ScoresUIKit
//
//  Created by Javier Rodríguez Gómez on 12/3/24.
//

import Foundation

// Extensión para el nombre de la notificación a usar para actualizar los cambios en los favoritos
// El controlador que modifica los favoritos al hacer swipe emite un post o señal que será escuchada por el controlador que muestra los favoritos

extension Notification.Name {
	static let favChanges = Notification.Name("FAVORITECHANGES")
}
