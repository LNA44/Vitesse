//
//  VitesseKeyChainService.swift
//  Vitesse
//
//  Created by Ordinateur elena on 28/03/2025.
//

import KeychainSwift
import Foundation

//Gère le token en le cryptant
class VitesseKeychainService: ObservableObject {
	
	private let keychain = KeychainSwift()
	
	func saveToken(token: String, key: String) -> Bool {
		return keychain.set(token, forKey: key)
	}
	
	func getToken(key: String) -> String? {
		return keychain.get(key)
	}
	
	func deleteToken(key: String) -> Bool {
		keychain.delete(key)
	}
}
