//
//  VitesseService.swift
//  Vitesse
//
//  Created by Ordinateur elena on 21/03/2025.
//

import Foundation

struct VitesseService {
	
	//MARK: -Properties
	let data: Data?
	let response: URLResponse?
	private let baseURLString: String
	private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse) // permet d'utiliser un mock
	private let keychain: KeyChainServiceProtocol // permet d'utiliser un mock
	var isAdmin: Bool = false

	//MARK: -Error enumerations
	enum LoginError: Error {
		case badURL
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	enum RegisterError: Error {
		case badURL
		case dataNotEmpty
		case requestFailed(String)
		case serverError(Int)
	}
	
	enum FetchCandidatesError: Error {
		case badURL
		case missingToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	enum FetchCandidateDetailsError: Error {
		case badURL
		case missingToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	enum AddCandidateError: Error {
		case badURL
		case missingToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	enum UpdateCandidateError: Error {
		case badURL
		case missingToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	enum DeleteCandidateError: Error {
		case badURL
		case missingToken
		case dataNotEmpty
		case requestFailed(String)
		case serverError(Int)
	}
	
	enum AddCandidateToFavoritesError: Error {
		case badURL
		case missingToken
		case notAdminToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	//MARK: -Initialisation
	init(data: Data? = nil, response: URLResponse? = nil, baseURLString: String = "http://127.0.0.1:8080",
		 executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:), keychain: KeyChainServiceProtocol) {
		self.data = data
		self.response = response
		self.baseURLString = baseURLString
		self.executeDataRequest = executeDataRequest
		self.keychain = keychain
	}
	
	//MARK: -Methods
	func login(email: String, password: String) async throws -> Bool {
		guard let baseURL = URL(string: baseURLString) else {
			throw LoginError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/user/auth")
		//body de la requete
		let parameters: [String: Any] = [
			"email": email,
			"password": password
		]
		
		//conversion en JSON
		let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw LoginError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw LoginError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw LoginError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let responseJSON = try? JSONDecoder().decode(VitesseLoginResponse.self, from: data) //décoder sous la forme VitesseLoginResponse
		else {
			throw LoginError.decodingError
		}
		//Stockage du token
		keychain.storeToken(token: responseJSON.token, key: "authToken")
		
		return isAdmin
	}
	
	func register(email: String, password: String, firstName: String, lastName: String) async throws -> Void {
		guard let baseURL = URL(string: baseURLString) else {
			throw RegisterError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/user/register")
		
		//body de la requete
		let parameters: [String: Any] = [
			"email": email,
			"password": password,
			"firstName": firstName,
			"lastName": lastName
		]
		
		//conversion en JSON
		let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData
				
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if !data.isEmpty {//data est non optionnel dc pas de guard let
			throw RegisterError.dataNotEmpty
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw RegisterError.requestFailed("Réponse du serveur invalide")
			
		}

		guard httpResponse.statusCode == 200 else {
			throw RegisterError.serverError(httpResponse.statusCode)
		}
	}
	
	func fetchCandidates() async throws -> [Candidate] {
		guard let baseURL = URL(string: baseURLString) else {
			throw FetchCandidatesError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "GET"
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw FetchCandidatesError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw FetchCandidatesError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw FetchCandidatesError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw FetchCandidatesError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let responseJSON = try? JSONDecoder().decode(VitesseCandidatesListResponse.self, from: data) else {
			throw FetchCandidatesError.decodingError
		}
		return responseJSON.candidates.map(Candidate.init)
	}
	
	func fetchCandidateDetails() async throws -> Candidate {
		guard let baseURL = URL(string: baseURLString) else {
			throw FetchCandidateDetailsError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/:candidateId")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "GET"
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw FetchCandidateDetailsError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw FetchCandidateDetailsError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw FetchCandidateDetailsError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw FetchCandidateDetailsError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw FetchCandidateDetailsError.decodingError
		}
		return candidate
	}
	
	func addCandidate(email: String, password: String, linkedinURL: String, firstName: String, lastName: String, phone: String) async throws -> Candidate {
		guard let baseURL = URL(string: baseURLString) else {
			throw AddCandidateError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate")
		
		//body de la requete
		let parameters: [String: Any] = [
			"email": email,
			"note": password,
			"linkedinURL": linkedinURL,
			"firstName": firstName,
			"lastName": lastName,
			"phone": phone
		]
		
		//conversion en JSON
		let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw AddCandidateError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw AddCandidateError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw AddCandidateError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw AddCandidateError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw AddCandidateError.decodingError
		}
		return candidate
	}
	
	func updateCandidate(email: String, password: String, linkedinURL: String, firstName: String, lastName: String, phone: String) async throws -> Candidate {
		guard let baseURL = URL(string: baseURLString) else {
			throw UpdateCandidateError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/:candidateId")
		
		//body de la requete
		let parameters: [String: Any] = [
			"email": email,
			"note": password,
			"linkedinURL": linkedinURL,
			"firstName": firstName,
			"lastName": lastName,
			"phone": phone
		]
		
		//conversion en JSON
		let	jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "PUT"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw UpdateCandidateError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw UpdateCandidateError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw UpdateCandidateError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw UpdateCandidateError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw UpdateCandidateError.decodingError
		}
		return candidate
	}
	
	func deleteCandidate() async throws -> Void {
		guard let baseURL = URL(string: baseURLString) else {
			throw DeleteCandidateError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/:candidateId")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "DELETE"
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw DeleteCandidateError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if !data.isEmpty {//data est non optionnel dc pas de guard let
			throw DeleteCandidateError.dataNotEmpty
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw DeleteCandidateError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw DeleteCandidateError.serverError(httpResponse.statusCode)
		}
	}
	
	func addCandidateToFavorites() async throws -> Candidate {
		if isAdmin == false {
			throw AddCandidateToFavoritesError.notAdminToken
		}
		
		guard let baseURL = URL(string: baseURLString) else {
			throw AddCandidateToFavoritesError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/:candidateId")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "POST"
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw AddCandidateToFavoritesError.missingToken
		}

		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw AddCandidateToFavoritesError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw AddCandidateToFavoritesError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw AddCandidateToFavoritesError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw AddCandidateToFavoritesError.decodingError
		}
		return candidate
	}
	
}
