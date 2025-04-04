//
//  CandidatesListViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 29/03/2025.
//

import Foundation

class CandidatesListViewModel: ObservableObject {
	//MARK: -Private properties
	private let repository: VitesseService

	//MARK: -Initialisation
	init(repository: VitesseService) {
		self.repository = repository
	}
	
	//MARK: -Outputs
	@Published var candidates: [Candidate]? = nil
	@Published var errorMessage: String? = nil
	@Published var isAdmin: Bool = false
	
	//MARK: -Inputs
	@MainActor
	func fetchCandidates() async {
		do {
			let candidates = try await repository.fetchCandidates()
			self.candidates = candidates
		} catch {
			if let FetchCandidatesError = error as? VitesseService.FetchCandidatesError { //si ok alors FetchCandidatesError = VitesseService.fetchCandidatesError sinon nil
				switch FetchCandidatesError {
				case .badURL:
					errorMessage = "URL non valide"
				case .missingToken:
					errorMessage = "Token manquant"
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
}

