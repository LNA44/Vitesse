//
//  VitesseService.swift
//  Vitesse
//
//  Created by Ordinateur elena on 21/03/2025.
//

import Foundation

struct VitesseService {
	let data: Data?
	let response: URLResponse?
	private let baseURLString: String
	private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse) // permet d'utiliser un mock
	private let keychain = VitesseKeyChainService.shared

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
	
	enum fetchCandidatesError: Error {
		case badURL
		case missingToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	enum fetchCandidateDetailsError: Error {
		case badURL
		case missingToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	enum addCandidateError: Error {
		case badURL
		case missingToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	enum updateCandidateError: Error {
		case badURL
		case missingToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}
	
	enum deleteCandidateError: Error {
		case badURL
		case missingToken
		case dataNotEmpty
		case requestFailed(String)
		case serverError(Int)
	}
	
	enum addCandidateToFavoritesError: Error {
		case badURL
		case missingToken
		case notAdminToken
		case noData
		case requestFailed(String)
		case serverError(Int)
		case decodingError
	}

	init(data: Data? = nil, response: URLResponse? = nil, baseURLString: String = "http://127.0.0.1:8080",
		 executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)) {
		self.data = data
		self.response = response
		self.baseURLString = baseURLString
		self.executeDataRequest = executeDataRequest
	}
	
	func login(username: String, password: String) async throws -> String {
		guard let baseURL = URL(string: baseURLString) else {
			throw LoginError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/user/auth")
		
		//body de la requete
		let parameters: [String: Any] = [
			"username": username,
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
		guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
			  let token = responseJSON["token"] else {
			throw LoginError.decodingError
		}
		//Stockage du token
		keychain.storeToken(token: token, key: "authToken")
		return token
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
			throw fetchCandidatesError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "GET"
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw fetchCandidatesError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw fetchCandidatesError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw fetchCandidatesError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw fetchCandidatesError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let responseJSON = try? JSONDecoder().decode(VitesseCandidatesListResponse.self, from: data) else {
			throw fetchCandidatesError.decodingError
		}
		return responseJSON.candidates.map(Candidate.init)
	}
	
	func fetchCandidateDetails() async throws -> Candidate {
		guard let baseURL = URL(string: baseURLString) else {
			throw fetchCandidateDetailsError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/:candidateId")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "GET"
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw fetchCandidateDetailsError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw fetchCandidateDetailsError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw fetchCandidateDetailsError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw fetchCandidateDetailsError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw fetchCandidateDetailsError.decodingError
		}
		return candidate
	}
	
	func addCandidate(email: String, password: String, linkedinURL: String, firstName: String, lastName: String, phone: String) async throws -> Candidate {
		guard let baseURL = URL(string: baseURLString) else {
			throw addCandidateError.badURL
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
			throw addCandidateError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw addCandidateError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw addCandidateError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw addCandidateError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw addCandidateError.decodingError
		}
		return candidate
	}
	
	func updateCandidate(email: String, password: String, linkedinURL: String, firstName: String, lastName: String, phone: String) async throws -> Candidate {
		guard let baseURL = URL(string: baseURLString) else {
			throw updateCandidateError.badURL
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
			throw updateCandidateError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw updateCandidateError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw updateCandidateError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw updateCandidateError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw updateCandidateError.decodingError
		}
		return candidate
	}
	
	func deleteCandidate() async throws -> Void {
		guard let baseURL = URL(string: baseURLString) else {
			throw deleteCandidateError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/:candidateId")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "DELETE"
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw deleteCandidateError.missingToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if !data.isEmpty {//data est non optionnel dc pas de guard let
			throw deleteCandidateError.dataNotEmpty
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw deleteCandidateError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw deleteCandidateError.serverError(httpResponse.statusCode)
		}
	}
	
	func addCandidateToFavorites() async throws -> Candidate {
		guard let baseURL = URL(string: baseURLString) else {
			throw addCandidateToFavoritesError.badURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/:candidateId")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "POST"
		
		//Récupération du token
		guard let token = keychain.retrieveToken(key: "authToken") else {
			throw addCandidateToFavoritesError.missingToken
		}
		let isAdmin = VitesseDecodageToken().decodeToken(token: token)
		if isAdmin == false {
			throw addCandidateToFavoritesError.notAdminToken
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw addCandidateToFavoritesError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw addCandidateToFavoritesError.requestFailed("Réponse du serveur invalide")
		}
		guard httpResponse.statusCode == 200 else {
			throw addCandidateToFavoritesError.serverError(httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw addCandidateToFavoritesError.decodingError
		}
		return candidate
	}
	
}
