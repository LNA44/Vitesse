//
//  LoginViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 01/04/2025.
//

import Foundation

class LoginViewModel: BaseViewModel {
	
	//MARK: - Private properties
	private let repository: VitesseAuthenticationRepository
	
	//MARK: -Initialisation
	init(repository: VitesseAuthenticationRepository) {
		self.repository = repository
	}
	
	//MARK: -Ouputs
	@Published var email: String = ""
	@Published var password: String = ""
	@Published var isAdmin: Bool = false
	
	var isSignUpComplete: Bool {
		if !isPasswordValid() || !isEmailValid() {
			return false
		}
		return true
	}
	
	var emailPrompt: String {
		if !isEmailValid() {
			return "Enter a valid email address"
		}
		return ""
	}
	
	var passwordPrompt: String {
		if !isPasswordValid() {
			return "Password must contain at least one letter, at least one number, and be longer than six charaters. "
		}
		return ""
	}
	
	//MARK: -Inputs
	@MainActor
	func login(email: String, password: String) async -> Bool {
		do {
			_ = try await repository.login(email: email, password: password)
			return true
		} catch {
			self.handleError(error)
			return false
		}
	}
	
	func isPasswordValid() -> Bool {
		// criterias here : http://regexlib.com
		let passwordTest = NSPredicate(format: "SELF MATCHES %@", Constantes.Regex.password)
		//Au moins 1 chiffre, au moins une lettre, au moins 6 caractères
		return passwordTest.evaluate(with: password)
	}
	
	func isEmailValid() -> Bool {
		// criterias here : http://regexlib.com
		let emailTest = NSPredicate(format: "SELF MATCHES %@", Constantes.Regex.email)
		/*Caractères précédants le @: 1 caractère alphanumérique (chiffre ou lettre), tiret point et underscores ok si suivies d'un caractère alphanumérique
		 Caractères suivants le @: 1 ou plusieurs caractères alphanumériques et tirets ou underscores (domaine de l'email)
		 Caractères après le point : entre 2 et 9 lettres (domaine de premier niveau : .com, .org,...)*/
		return emailTest.evaluate(with: email)
	}
}
