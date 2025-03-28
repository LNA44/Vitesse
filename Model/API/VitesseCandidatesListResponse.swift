//
//  VitesseResponse.swift
//  Vitesse
//
//  Created by Ordinateur elena on 21/03/2025.
//

import Foundation
struct VitesseCandidatesListResponse: Decodable {
	let candidates: [Candidate]
	
	//MARK: -Candidate
	struct Candidate: Decodable {
		let phone: String?
		let note: String?
		let id: String
		let firstName: String
		let linkedinURL: String?
		let isFavorite: Bool
		let email: String
		let lastName: String
	}
}
