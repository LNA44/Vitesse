//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 03/04/2025.
//

import Foundation

class RegisterViewModel: ObservableObject {
	//MARK: -Private properties
	private let repository: VitesseRepository
	
	//MARK: -Initialisation
	init(repository: VitesseRepository) {
		self.repository = repository
	}
	
	//MARK: -Outputs
	@Published var email: String = ""
	@Published var password: String = ""
	@Published var confirmPassword: String = ""
	@Published var firstName: String = ""
	@Published var lastName: String = ""
	@Published var errorMessage: String?
	@Published var transferMessage: String = ""
	
	var isSignUpComplete: Bool {
		if !isFirstNameValid() || !isLastNameValid() || !isEmailValid() || !isPasswordValid() || verifyPasswordPrompt != "" {
			return false
		}
		return true
	}
	
	var firstNamePrompt: String {
		if !isFirstNameValid() {
			return "Enter a valid first name"
		}
		return ""
	}
	
	var lastNamePrompt: String {
		if !isLastNameValid() {
			return "Enter a valid last name"
		}
		return ""
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
	
	var verifyPasswordPrompt: String {
		if password == confirmPassword {
			return ""
		}
		return "Passwords are different"
	}

	//MARK: -Inputs
	@MainActor
	func addUser() async {
		do {
			_ = try await repository.register(email: email, password: password, firstName: firstName, lastName: lastName)
			transferMessage = "Successfully registered"
		} catch let error as APIError {
			errorMessage = error.errorDescription
		} catch {
			errorMessage = "Une erreur inconnue est survenue : \(error.localizedDescription)"
		}
	}
	
	@MainActor
	func addCandidate() async {
		do {
			_ = try await repository.login(email: email, password: password) //permet de récupérer le token utile à addCandidate
			print("on est dans VM.addCandidate")
			_ = try await repository.addCandidate(email: email, firstName: firstName, lastName: lastName)
			_ = VitesseKeychainService().deleteToken(key: "authToken")
		} catch let error as APIError {
			errorMessage = error.errorDescription
		} catch {
			errorMessage = "Une erreur inconnue est survenue : \(error.localizedDescription)"
		}
	}
	
	func isFirstNameValid() -> Bool {
		// criterias here : http://regexlib.com
		let firstNameTest = NSPredicate(format: "SELF MATCHES %@","^([^ \\x21-\\x26\\x28-\\x2C\\x2E-\\x40\\x5B-\\x60\\x7B-\\xAC\\xAE-\\xBF\\xF7\\xFE]+)$" )
		//Accepte les accents
		return firstNameTest.evaluate(with: firstName)
	}
	
	func isLastNameValid() -> Bool {
		// criterias here : http://regexlib.com
		let lastNameTest = NSPredicate(format: "SELF MATCHES %@","^([^ \\x21-\\x26\\x28-\\x2C\\x2E-\\x40\\x5B-\\x60\\x7B-\\xAC\\xAE-\\xBF\\xF7\\xFE]+)$" )
		//Accepte les accents et les tirets
		return lastNameTest.evaluate(with: lastName)
	}
	
	func isEmailValid() -> Bool {
		// criterias here : http://regexlib.com
		let emailTest = NSPredicate(format: "SELF MATCHES %@","^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\\w]*[0-9a-zA-Z])*\\.)+[a-zA-Z]{2,9})$" )
		/*Caractères précédants le @: 1 caractère alphanumérique (chiffre ou lettre), tiret point et underscores ok si suivies d'un caractère alphanumérique
		Caractères suivants le @: 1 ou plusieurs caractères alphanumériques et tirets ou underscores (domaine de l'email)
		Caractères après le point : entre 2 et 9 lettres (domaine de premier niveau : .com, .org,...)*/
		return emailTest.evaluate(with: email)
	}
	
	func isPasswordValid() -> Bool {
		// criterias here : http://regexlib.com
		let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$" )
		//Au moins 1 chiffre, au moins une lettre, au moins 6 caractères
		return passwordTest.evaluate(with: password)
	}
	
}
