//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 03/04/2025.
//

import Foundation

class RegisterViewModel: BaseViewModel {
	//MARK: -Private properties
	private let authRepository: VitesseAuthenticationRepository
	private let candidateRepository: VitesseCandidateRepository
	
	//MARK: -Initialisation
	init(authRepository: VitesseAuthenticationRepository, candidateRepository: VitesseCandidateRepository) {
		self.authRepository = authRepository
		self.candidateRepository = candidateRepository
	}
	
	//MARK: -Outputs
	@Published var email: String = ""
	@Published var password: String = ""
	@Published var confirmPassword: String = ""
	@Published var firstName: String = ""
	@Published var lastName: String = ""
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
		print("🔎 addUser called")
		do {
			_ = try await authRepository.register(email: email, password: password, firstName: firstName, lastName: lastName)
			transferMessage = "Successfully registered"
		} catch {
			print("erreur dans addUser")
			self.handleErrorWithoutKeychain(error)
		}
	}
	
	@MainActor
	func addCandidate() async {
		print("🔎 addUCandidate called")
		do {
			_ = try await authRepository.login(email: email, password: password) //permet de récupérer le token utile à addCandidate
			_ = try await candidateRepository.addCandidate(email: email, firstName: firstName, lastName: lastName)
			_ = try VitesseKeychainService().deleteToken(key: "authToken")
		} catch {
			self.handleError(error)
		}
	}
	
	func isFirstNameValid() -> Bool {
		// criterias here : http://regexlib.com
		let firstNameTest = NSPredicate(format: "SELF MATCHES %@", Constantes.Regex.firstName)
		//Accepte les accents
		return firstNameTest.evaluate(with: firstName)
	}
	
	func isLastNameValid() -> Bool {
		// criterias here : http://regexlib.com
		let lastNameTest = NSPredicate(format: "SELF MATCHES %@", Constantes.Regex.lastName)
		//Accepte les accents et les tirets
		return lastNameTest.evaluate(with: lastName)
	}
	
	func isEmailValid() -> Bool {
		// criterias here : http://regexlib.com
		let emailTest = NSPredicate(format: "SELF MATCHES %@", Constantes.Regex.email)
		/*Caractères précédants le @: 1 caractère alphanumérique (chiffre ou lettre), tiret point et underscores ok si suivies d'un caractère alphanumérique
		 Caractères suivants le @: 1 ou plusieurs caractères alphanumériques et tirets ou underscores (domaine de l'email)
		 Caractères après le point : entre 2 et 9 lettres (domaine de premier niveau : .com, .org,...)*/
		return emailTest.evaluate(with: email)
	}
	
	func isPasswordValid() -> Bool {
		// criterias here : http://regexlib.com
		let passwordTest = NSPredicate(format: "SELF MATCHES %@", Constantes.Regex.password)
		//Au moins 1 chiffre, au moins une lettre, au moins 6 caractères
		return passwordTest.evaluate(with: password)
	}
	
}
