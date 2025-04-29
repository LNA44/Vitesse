//
//  VitesseAppViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 29/03/2025.
//

import Foundation
//crée les instances des VM qui sont rechargées à chaque fois que la vue est mise à jour
class VitesseAppViewModel: ObservableObject {
	//MARK: -Properties
	//@Published var isLogged: Bool = false
	@Published var isAdmin: Bool = false
	
/*	//MARK: - Initialisation
	init(repository: VitesseService) {
		self.repository = repository
		self.isLogged = false
		self.isAdmin = false
	}
	
	//MARK: - Computed properties
	var loginViewModel: LoginViewModel {
		return LoginViewModel(repository: repository) { [weak self] isLogged, isAdmin in
			self?.isLogged = isLogged
			self?.isAdmin = isAdmin
		}
	}*/
}
