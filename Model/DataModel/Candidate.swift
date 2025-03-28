//
//  Candidate.swift
//  Vitesse
//
//  Created by Ordinateur elena on 21/03/2025.
//

import Foundation
//modèle interne à l'app

struct Candidate: Decodable {
	var internalId = UUID() //utile pour liste
	let phone: String?
	let note: String?
	let id: String
	let firstName: String
	let linkedinURL: String?
	let isFavorite: Bool
	let email: String
	let lastName: String
	
	//MARK: -Init
	init(candidate: VitesseCandidatesListResponse.Candidate) {
		self.email = candidate.email
		self.firstName = candidate.firstName
		self.id = candidate.id
		self.isFavorite = candidate.isFavorite
		self.lastName = candidate.lastName
		self.linkedinURL = candidate.linkedinURL ?? "" // Si nil, mettre une chaîne vide
		self.note = candidate.note ?? "" // Si nil, mettre une chaîne vide
		self.phone = candidate.phone ?? "" // Si nil, mettre une chaîne vide
	}
}
