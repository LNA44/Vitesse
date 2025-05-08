//
//  VitesseCandidateRepository.swift
//  Vitesse
//
//  Created by Ordinateur elena on 30/04/2025.
//

import Foundation

struct VitesseCandidateRepository {
	//MARK: -Properties
	private let keychain: VitesseKeychainService
	private let APIService: VitesseAPIService
	
	//MARK: -Initialization
	init(keychain: VitesseKeychainService, APIService: VitesseAPIService = VitesseAPIService()) {
		self.keychain = keychain
		self.APIService = APIService
	}
	
	//MARK: -Methods
	func fetchCandidates() async throws -> [Candidate] {
		let endpoint = try APIService.createEndpoint(path: .fetchCandidatesOrAddCandidate)
		var request = APIService.createRequest(jsonData: nil, endpoint: endpoint, method: .get)
		
		let token = try keychain.getToken(key: Constantes.Candidate.tokenKey)
		
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

		let candidates = try await APIService.fetchAndDecode([Candidate].self, request: request)
		
		guard let unwrappedCandidates = candidates else {
			throw APIError.noData
		}
		
		return unwrappedCandidates
		
	}
	
	/*func fetchCandidateDetails(id: String) async throws -> Candidate {
		let endpoint = try APIService.createEndpoint(path: .fetchOrUpdateOrDeleteCandidateWithID(id: id))
		var request = APIService.createRequest(jsonData: nil, endpoint: endpoint, method: .get)
		
		guard let token = keychain.getToken(key: "authToken") else {
			throw APIError.unauthorized
		}
		
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		let candidate = try await APIService.fetchAndDecode(Candidate.self, request: request)
		
		guard let unwrappedCandidate = candidate else {
			throw APIError.noData
		}
		
		return unwrappedCandidate
	}*/
	
	func addCandidate(email: String, firstName: String, lastName: String) async throws -> Bool {
		let endpoint = try APIService.createEndpoint(path: .fetchCandidatesOrAddCandidate)
		
		//body de la requete
		let parameters: [String: Any?] = [
			"email": email,
			"note": nil,
			"linkedinURL": nil,
			"firstName": firstName,
			"lastName": lastName,
			"phone": nil
		]
		
		let nonNilSafeParameters = parameters.mapValues { $0 as Any } // Force le cast de Any? en Any pour éviter le warning
		
		let jsonData = try APIService.serializeParameters(parameters: nonNilSafeParameters)
		var request = APIService.createRequest(parameters: nonNilSafeParameters, jsonData: jsonData, endpoint: endpoint, method: .post)
		
		let token = try keychain.getToken(key: Constantes.Candidate.tokenKey)
		
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		_ = try await APIService.fetchAndDecode(Candidate.self, request: request)
		
		return true
	}
	
	func updateCandidate(id:String, email: String, note: String?, linkedinURL: String?, firstName: String, lastName: String, phone: String?) async throws -> Candidate {
		let endpoint = try APIService.createEndpoint(path: .fetchOrUpdateOrDeleteCandidateWithID(id: id))
		
		//body de la requete
		let parameters: [String: Any?] = [
			"email": email,
			"note": note,
			"linkedinURL": linkedinURL,
			"firstName": firstName,
			"lastName": lastName,
			"phone": phone
		]
		let nonNilSafeParameters = parameters.mapValues { $0 as Any } // Force le cast de Any? en Any pour éviter le warning
		let jsonData = try APIService.serializeParameters(parameters: nonNilSafeParameters)
		var request = APIService.createRequest(parameters: nonNilSafeParameters, jsonData: jsonData, endpoint: endpoint, method: .put)
		
		let token = try keychain.getToken(key: Constantes.Candidate.tokenKey)
		
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		let candidate = try await APIService.fetchAndDecode(Candidate.self, request: request)
		guard let unwrappedCandidate = candidate else {
			throw APIError.noData
		}
		
		return unwrappedCandidate
	}
	
	func deleteCandidate(id: String) async throws -> Bool {
		let endpoint = try APIService.createEndpoint(path: .fetchOrUpdateOrDeleteCandidateWithID(id: id))
		var request = APIService.createRequest(jsonData: nil, endpoint: endpoint, method: .delete)
		let token = try keychain.getToken(key: Constantes.Candidate.tokenKey)
		
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		_ = try await APIService.fetch(request: request, allowEmptyData: true)
		
		return true
	}
	
	func addCandidateToFavorites(id: String) async throws -> Candidate { //renvoie la valeur inversée de isFavorite
		let endpoint = try APIService.createEndpoint(path: .candidateWithIDInFavorites(id: id))
		var request = APIService.createRequest(jsonData: nil, endpoint: endpoint, method: .post)
		let token = try keychain.getToken(key: Constantes.Candidate.tokenKey) 
		
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		let candidate = try await APIService.fetchAndDecode(Candidate.self, request: request)
		guard let unwrappedCandidate = candidate else {
			throw APIError.noData
		}
		
		return unwrappedCandidate
	}
}
