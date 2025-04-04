//
//  LoginViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 01/04/2025.
//

import Foundation

class LoginViewModel: ObservableObject {
	
	//MARK: - Private properties
	private let repository: VitesseService
	
	//MARK: -Initialisation
	init(repository: VitesseService, _ callback: @escaping ((Bool, Bool) -> Void)) {
		self.repository = repository
		self.onLoginSucceed = callback
	}
	
	//MARK: -Ouputs
	@Published var email: String = ""
	@Published var password: String = ""
	@Published var isAdmin: Bool = false
	@Published var errorMessage: String? = nil
	var onLoginSucceed: ((Bool, Bool) -> Void)  // Callback avec isLogged et isAdmin
	
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
	func login(email: String, password: String) async {
		do {
			let isAdmin = try await repository.login(email: email, password: password)
			self.onLoginSucceed(true, isAdmin) //exécute la closure du callback dans VitesseAppViewModel
		} catch {
			self.onLoginSucceed(false, false)
			if let LoginError = error as? VitesseService.LoginError { //si ok alors FetchCandidatesError = VitesseService.fetchCandidatesError sinon nil
				switch LoginError {
				case .badURL:
					errorMessage = "URL non valide"
				case .noData:
					errorMessage = "Aucune donnée disponible"
				case .requestFailed:
					errorMessage = "Erreur de requête"
				case .serverError:
					errorMessage = "Erreur du serveur "
				case .decodingError:
					errorMessage = "Erreur de décodage des données"
				}
			}
		}
	}
	
	func isPasswordValid() -> Bool {
		// criterias here : http://regexlib.com
		let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$" )
		//Au moins 1 chiffre, au moins une lettre, au moins 6 caractères
		return passwordTest.evaluate(with: password)
	}
	
	func isEmailValid() -> Bool {
		// criterias here : http://regexlib.com
		let emailTest = NSPredicate(format: "SELF MATCHES %@","^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\\w]*[0-9a-zA-Z])*\\.)+[a-zA-Z]{2,9})$" )
		/*Caractères précédants le @: 1 caractère alphanumérique (chiffre ou lettre), tiret point et underscores ok si suivies d'un caractère alphanumérique
		Caractères suivants le @: 1 ou plusieurs caractères alphanumériques et tirets ou underscores (domaine de l'email)
		Caractères après le point : entre 2 et 9 lettres (domaine de premier niveau : .com, .org,...)*/
		return emailTest.evaluate(with: email)
	}
}
