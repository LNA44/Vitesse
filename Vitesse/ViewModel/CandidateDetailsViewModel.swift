//
//  CandidateDetailsViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 28/03/2025.
//

import Foundation

class CandidateDetailsViewModel: ObservableObject {
	//MARK: -Private properties
	private let repository: VitesseService

	//MARK: -Initialisation
	init(repository: VitesseService) {
		self.repository = repository
	}
	
	//MARK: -Outputs
	@Published var candidate: Candidate?
	@Published var url: URL?
	
	//MARK: -Inputs
	
	func convertStringToURL(_ urlString: String?) {
		guard let urlString = urlString, let validUrl = URL(string: urlString) else { //vérifie que urlString n'est pas nil
			url = nil
			return
		}
		url = validUrl
	}
}
