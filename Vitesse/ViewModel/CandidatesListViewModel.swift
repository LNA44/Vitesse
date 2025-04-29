//
//  CandidatesListViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 29/03/2025.
//

import Foundation

class CandidatesListViewModel: ObservableObject {
	//MARK: -Private properties
	private let repository: VitesseRepository

	//MARK: -Initialisation
	init(repository: VitesseRepository) {
		self.repository = repository
	}
	
	//MARK: -Outputs
	@Published var showAlert: Bool = false
	@Published var candidates: [Candidate]? = nil
	@Published var errorMessage: String? = nil
	@Published var isAdmin: Bool = false
	@Published var selectedCandidates: [UUID] = []
	
	//MARK: -Inputs
	@MainActor
	func fetchCandidates() async {
		do {
			let candidates = try await repository.fetchCandidates()
			self.candidates = candidates
		} catch let error as APIError {
			errorMessage = error.errorDescription
		} catch {
			errorMessage = "Une erreur inconnue est survenue : \(error.localizedDescription)"
		}
	}
	
	@MainActor
	func deleteCandidate(id: String) async {
		do {
			_ = try await repository.deleteCandidate(id: id)
		} catch let error as APIError {
			errorMessage = error.errorDescription
			showAlert = true
		} catch {
			errorMessage = "Une erreur inconnue est survenue : \(error.localizedDescription)"
			showAlert = true
		}
	}
	
	func toggleSelection(candidate: Candidate) {
		if let index = selectedCandidates.firstIndex(of: candidate.idUUID) {
			selectedCandidates.remove(at: index)
		} else {
			selectedCandidates.append(candidate.idUUID)
		}
	}
	
	/*// Fonction pour basculer l'état de favoris d'un candidat
	func toggleFavorite(candidate: Candidate) async {
		guard var candidates = self.candidates else { //donne la valeur de la propriété candidates à la var candidates et unwrap l'optionnel
			// Si candidates est nil, on ne fait rien ou on gère l'erreur ici
			return
		}
		if let index = candidates.firstIndex(where: { $0.idUUID == candidate.idUUID }) {
			// Inverser l'état de favoris du candidat
			candidates[index].isFavorite.toggle()
			
			// Enregistrer les modifications dans le backend si nécessaire
			do {
				_ = try await repository.updateCandidate(id: candidate.id, email: candidate.email, note: candidate.note, linkedinURL: candidate.linkedinURL, firstName: candidate.firstName, lastName: candidate.lastName, phone: candidate.phone)
				self.candidates = candidates //Réaffecter la valeur à la propriété d'instance
			} catch let error as APIError {
				errorMessage = error.errorDescription
				showAlert = true
			} catch {
				errorMessage = "Une erreur inconnue est survenue : \(error.localizedDescription)"
				showAlert = true
			}
		}
	}*/
}

