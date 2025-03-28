//
//  VitesseDecodageToken.swift
//  Vitesse
//
//  Created by Ordinateur elena on 28/03/2025.
//

import Foundation

class VitesseDecodageToken: ObservableObject {
	let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFkbWluQHZpdGVzc2UuY29tIiwiaXNBZG1pbiI6dHJ1ZX0.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U"

	// Décoder la partie Payload du JWT
	let components = token.split(separator: ".")
	if components.count == 3 {
		let payloadBase64 = components[1]
		if let decodedData = Data(base64Encoded: String(payloadBase64)) {
			if let json = try? JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any],
			   let isAdmin = json["isAdmin"] as? Bool {
				if isAdmin {
					print("L'utilisateur est un administrateur")
				} else {
					print("L'utilisateur n'est pas un administrateur")
				}
			}
		}
	}
}
