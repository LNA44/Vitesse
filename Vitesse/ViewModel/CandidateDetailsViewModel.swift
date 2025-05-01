//
//  CandidateDetailsViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 28/03/2025.
//

import Foundation

class CandidateDetailsViewModel: ObservableObject {
	//MARK: -Private properties
	private let repository: VitesseCandidateRepository

	//MARK: -Initialisation
	init(repository: VitesseCandidateRepository, candidate: Candidate, id: String, email: String, phone: String?, linkedinURL: String?, note: String?, firstName: String, lastName: String, isFavorite: Bool) {
		self.repository = repository
		self.candidate = candidate
		self.id = id
		self.email = email
		self.phone = phone
		self.linkedinURL = linkedinURL
		self.note = note
		self.firstName = firstName
		self.lastName = lastName
		self.phone  = phone
		self.isFavorite = isFavorite
	}
	
	//MARK: -Outputs
	@Published var showAlert: Bool = false
	@Published var candidate: Candidate
	@Published var id: String
	@Published var email: String
	@Published var phone: String?
	@Published var linkedinURL: String?
	@Published var note: String?
	@Published var firstName: String
	@Published var lastName: String
	@Published var errorMessage: String? = ""
	@Published var isFavorite: Bool
	
	//MARK: -Inputs
	
	func convertStringToURL(_ urlString: String?) ->URL? {
		guard let urlString = urlString, let validUrl = URL(string: urlString) else { //vérifie que urlString n'est pas nil
			return nil
		}
		return validUrl
	}
	
	@MainActor
	func updateCandidate() async {
		candidate.id = id
		candidate.firstName = firstName
		candidate.lastName = lastName
		candidate.email = email
		candidate.note = note
		candidate.linkedinURL = linkedinURL
		candidate.phone = phone
		do {
			_ = try await repository.updateCandidate(id: id, email: email, note: note, linkedinURL: linkedinURL, firstName: firstName, lastName: lastName, phone: phone)
		} catch let error as APIError {
			errorMessage = error.errorDescription
		} catch {
			errorMessage = "Une erreur inconnue est survenue : \(error.localizedDescription)"
		}
	}
	
	// Fonction pour basculer l'état de favoris d'un candidat
	@MainActor
	func toggleFavorite() async {
		// Inverse l'état de isFavorite dans le backend
		do {
			let updatedCandidate = try await repository.addCandidateToFavorites(id: candidate.id)
			self.candidate = updatedCandidate
			self.isFavorite = updatedCandidate.isFavorite //affecte la valeur à la propriété
		} catch let error as APIError {
			errorMessage = error.errorDescription
			showAlert = true
		} catch {
			errorMessage = "Une erreur inconnue est survenue : \(error.localizedDescription)"
			showAlert = true
		}
	}
}
