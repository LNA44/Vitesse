//
//  Candidate.swift
//  Vitesse
//
//  Created by Ordinateur elena on 21/03/2025.
//

import Foundation
//modèle interne à l'app

struct Candidate: Codable {//var: car modifiées dans CandidateDetailsVM
	var phone: String?
	var note: String?
	var id: String
	var firstName: String
	var linkedinURL: String?
	var isFavorite: Bool
	var email: String
	var lastName: String
	
	//MARK: -Init
	init(candidate: Candidate) {
		self.phone = candidate.phone ?? "" // Si nil, mettre une chaîne vide
		self.note = candidate.note ?? "" // Si nil, mettre une chaîne vide
		self.id = candidate.id
		self.firstName = candidate.firstName
		self.linkedinURL = candidate.linkedinURL ?? "" // Si nil, mettre une chaîne vide
		self.isFavorite = candidate.isFavorite
		self.email = candidate.email
		self.lastName = candidate.lastName
	}
	
	//MARK: -Calculated properties
	var idUUID: UUID {
		return UUID(uuidString: id) ?? UUID() //utile pour liste
	}
}
