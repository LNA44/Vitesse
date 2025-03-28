//
//  VitesseDecodageToken.swift
//  Vitesse
//
//  Created by Ordinateur elena on 28/03/2025.
//

import Foundation

class VitesseDecodageToken: ObservableObject {
	@Published var userIsAdmin: Bool = false
	
	func decodeToken(token: String) -> Bool {
		// Décoder la partie Payload du JWT
		let components = token.split(separator: ".")
		guard components.count == 3 else {
			return false
		}
		let payloadBase64 = components[1]
		guard let decodedData = Data(base64Encoded: String(payloadBase64)) else {
			return false
		}
		guard let json = try? JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any],
			  let isAdmin = json["isAdmin"] as? Bool else {
			return false
		}
		return true
	}
}
