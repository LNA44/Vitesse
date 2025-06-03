//
//  ErrorHandler.swift
//  Vitesse
//
//  Created by Ordinateur elena on 13/05/2025.
//

import Foundation
//Les VM's héritent de cette classe
class BaseViewModel: ObservableObject {
	@Published var errorMessage: String? = ""
	@Published var showAlert: Bool = false
	
	func handleError(_ error: Error) {
		if let keychainError = error as? VitesseKeychainService.KeychainError {
			errorMessage = keychainError.errorKeychainDescription
		} else if let apiError = error as? APIError {
			errorMessage = apiError.errorDescription
		} else {
			errorMessage = "Unknown error happened : \(error.localizedDescription)"
		}
		print("⚠️ handleError triggered with message: \(errorMessage ?? "nil")")
		showAlert = true
	}
	
	// Variante sans gestion des erreurs Keychain
	func handleErrorWithoutKeychain(_ error: Error) {
		if let apiError = error as? APIError {
			errorMessage = apiError.errorDescription
		} else {
			errorMessage = "Unknown error happened : \(error.localizedDescription)"
		}
		showAlert = true
	}
}
