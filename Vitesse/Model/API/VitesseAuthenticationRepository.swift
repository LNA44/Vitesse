//
//  VitesseAuthenticationRepository.swift
//  Vitesse
//
//  Created by Ordinateur elena on 30/04/2025.
//

import Foundation

struct VitesseAuthenticationRepository {
	//MARK: -Properties
	private let keychain: VitesseKeychainService
	private let APIService: VitesseAPIService
	private var isAdmin: Bool = false
	
	//MARK: -Initialization
	init(keychain: VitesseKeychainService, APIService: VitesseAPIService = VitesseAPIService()) {
		self.keychain = keychain
		self.APIService = APIService
	}
	
	//MARK: -Methods
	func login(email: String, password: String) async throws -> Bool {
		let endpoint = try APIService.createEndpoint(path: .login)
		
		//body de la requete
		let parameters: [String: Any] = [
			"email": email,
			"password": password
		]
		
		let jsonData = try APIService.serializeParameters(parameters: parameters)
		let request = APIService.createRequest(parameters: parameters, jsonData: jsonData, endpoint: endpoint, method: .post)
		let responseJSON = try await APIService.fetchAndDecode(VitesseLoginResponse.self, request: request)
		
		guard let unwrappedResponseJSON = responseJSON else {
			throw APIError.noData
		}
		//Stockage du token
		_ = keychain.saveToken(token: unwrappedResponseJSON.token, key: Constantes.Authentication.tokenKey)
		
		return isAdmin
	}
	
	func register(email: String, password: String, firstName: String, lastName: String) async throws -> Bool {
		let endpoint = try APIService.createEndpoint(path: .registrer)
		
		//body de la requete
		let parameters: [String: Any] = [
			"email": email,
			"password": password,
			"firstName": firstName,
			"lastName": lastName
		]
		
		let jsonData = try APIService.serializeParameters(parameters: parameters)
		let request = APIService.createRequest(parameters: parameters, jsonData: jsonData, endpoint: endpoint, method: .post)
		let _ = try await APIService.fetchAndDecode(Candidate.self, request: request)
		
		return true
	}
	
	
}
