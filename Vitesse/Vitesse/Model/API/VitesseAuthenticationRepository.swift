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
	
	//MARK: -Initialization
	init(keychain: VitesseKeychainService, APIService: VitesseAPIService = VitesseAPIService()) {
		self.keychain = keychain
		self.APIService = APIService
	}
	
	//MARK: -Methods
	func login(email: String, password: String) async throws {
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
		_ = try keychain.saveToken(token: unwrappedResponseJSON.token, key: Constantes.Authentication.tokenKey)
	}
	
	func register(email: String, password: String, firstName: String, lastName: String) async throws -> Bool {
		let endpoint = try APIService.createEndpoint(path: .register)
		
		//body de la requete
		let parameters: [String: Any] = [
			"email": email,
			"password": password,
			"firstName": firstName,
			"lastName": lastName
		]
		
		let jsonData = try APIService.serializeParameters(parameters: parameters)
		let request = APIService.createRequest(parameters: parameters, jsonData: jsonData, endpoint: endpoint, method: .post)
		_ = try await APIService.fetch(request: request, allowEmptyData: true, allowStatusCode201: true)
		
		return true
	}
}
