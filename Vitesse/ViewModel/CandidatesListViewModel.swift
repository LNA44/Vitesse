//
//  CandidatesListViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 29/03/2025.
//

import Foundation

class CandidatesListViewModel: ObservableObject {
	//MARK: -Private properties
	private let repository: VitesseCandidateRepository

	//MARK: -Initialisation
	init(repository: VitesseCandidateRepository) {
		self.repository = repository
	}
	
	//MARK: -Outputs
	@Published var showAlert: Bool = false
	@Published var searchText: String = "" {
		didSet { //filtre réappliqué à chaque changement d'état de searchText
			applyFilters(filterFavorites: filterFavorites, filterName: searchText)
		}
	}
	@Published var candidates: [Candidate]? = nil {
		didSet { //filtre appliqué uniquement après que candidate soit chargé
			applyFilters(filterFavorites: filterFavorites, filterName: searchText)
		}
	}
	@Published var errorMessage: String? = nil
	@Published var selectedCandidates: [UUID] = []
	@Published var filterFavorites: Bool = false {
		didSet { //filtre réappliqué à chaque changement d'état de filterFavorites
			applyFilters(filterFavorites: filterFavorites, filterName: searchText)
		}
	}
	@Published var filteredFavCandidates : [Candidate] = []
	@Published var filteredNameCandidates : [Candidate] = []
	
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
	
	func applyFilters(filterFavorites: Bool, filterName: String) {
		guard let candidates = candidates else {
			return
		}
		// Filtrage par favoris
		if filterFavorites == true {
			filteredFavCandidates = candidates.filter{$0.isFavorite}
		} else {
			filteredFavCandidates = candidates
		}
		// Filtrage par nom/prénom
		if !searchText.isEmpty {
			filteredNameCandidates = filteredFavCandidates.filter { candidate in
				let firstNameMatch = candidate.firstName.lowercased().contains(filterName.lowercased())
				let lastNameMatch = candidate.lastName.lowercased().contains(filterName.lowercased())
				return firstNameMatch || lastNameMatch
			}
		} else {
			filteredNameCandidates = filteredFavCandidates
		}
	}
}

