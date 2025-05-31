//
//  CandidateDetailsViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 28/03/2025.
//

import Foundation

class CandidateDetailsViewModel: BaseViewModel {
	//MARK: -Private properties
	private let repository: VitesseCandidateRepository
	private let candidateID: String
	
	//MARK: -Initialisation
	init(repository: VitesseCandidateRepository, candidateID: String) {
		self.repository = repository
		self.candidateID = candidateID
		self.email = ""
		self.firstName = ""
		self.lastName = ""
		self.isFavorite = false
	}
	
	//MARK: -Outputs
	@Published var email: String
	@Published var phone: String?
	@Published var linkedinURL: String?
	@Published var note: String?
	@Published var firstName: String
	@Published var lastName: String
	@Published var isFavorite: Bool
	
	//MARK: -Inputs
	
	func convertStringToURL(_ urlString: String?) ->URL? {
		guard let urlString = urlString, let validUrl = URL(string: urlString) else { //vérifie que urlString n'est pas nil
			return nil
		}
		return validUrl
	}
	
	@MainActor
	func fetchCandidateDetails() async {
		do {
			let candidate = try await repository.fetchCandidateDetails(id: candidateID)
			self.firstName = candidate.firstName
			self.lastName = candidate.lastName
			self.email = candidate.email
			self.phone = candidate.phone
			self.linkedinURL = candidate.linkedinURL
			self.note = candidate.note
			self.isFavorite = candidate.isFavorite
		} catch {
			self.handleError(error)
		}
	}
	
	@MainActor
	func updateCandidate() async {
		do {
			_ = try await repository.updateCandidate(id: candidateID, email: email, note: note, linkedinURL: linkedinURL, firstName: firstName, lastName: lastName, phone: phone)
		} catch {
			self.handleError(error)
		}
	}
	
	// Fonction pour basculer l'état de favoris d'un candidat
	@MainActor
	func toggleFavorite() async {
		// Inverse l'état de isFavorite dans le backend
		do {
			let updatedCandidate = try await repository.addCandidateToFavorites(id: candidateID)
			self.isFavorite = updatedCandidate.isFavorite //affecte la valeur à la propriété
		} catch {
			self.handleError(error)
		}
	}
}
