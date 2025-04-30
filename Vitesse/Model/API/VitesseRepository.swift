//
//  VitesseService.swift
//  Vitesse
//
//  Created by Ordinateur elena on 21/03/2025.
//

import Foundation

struct VitesseRepository {
	
	//MARK: -Properties
	let data: Data?
	let response: URLResponse?
	private let baseURLString: String
	private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse) // permet d'utiliser un mock
	private let keychain: VitesseKeychainService // permet d'utiliser un mock
	var isAdmin: Bool = false
	private let APIService: VitesseAPIService

	//MARK: -Error enumerations
	/*enum LoginError: Error {
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
	}*/
	
	//MARK: -Initialisation
	init(data: Data? = nil, response: URLResponse? = nil, baseURLString: String = "http://127.0.0.1:8080",
		 executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:), keychain: VitesseKeychainService, APIService: VitesseAPIService = VitesseAPIService()) {
		self.data = data
		self.response = response
		self.baseURLString = baseURLString
		self.executeDataRequest = executeDataRequest
		self.keychain = keychain
		self.APIService = APIService
	}
	
	//MARK: -Methods
	func login(email: String, password: String) async throws -> Bool {
		guard let baseURL = URL(string: baseURLString) else {
			throw APIError.invalidURL
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
			throw APIError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw APIError.invalidResponse
		}
		guard httpResponse.statusCode == 200 else {
			throw APIError.httpError(statusCode: httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let responseJSON = try? JSONDecoder().decode(VitesseLoginResponse.self, from: data) //décoder sous la forme VitesseLoginResponse
		else {
			throw APIError.decodingError
		}
		//Stockage du token
		_ = keychain.saveToken(token: responseJSON.token, key: "authToken")
		
		return isAdmin
	}
	
	func register(email: String, password: String, firstName: String, lastName: String) async throws -> Bool {
		guard let baseURL = URL(string: baseURLString) else {
			throw APIError.invalidURL
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
		let (_, response) = try await executeDataRequest(request)
		
		/*if !data.isEmpty {//data est non optionnel dc pas de guard let
			throw APIError.dataEmpty
		}*/
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw APIError.invalidResponse
			
		}

		guard httpResponse.statusCode == 200 else {
			throw APIError.httpError(statusCode: httpResponse.statusCode)
		}
		
		return true
	}
	
	func fetchCandidates() async throws -> [Candidate] {
		guard let baseURL = URL(string: baseURLString) else {
			throw APIError.invalidURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate")
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "GET"
		
		//Récupération du token
		guard let token = keychain.getToken(key: "authToken") else {
			throw APIError.unauthorized
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw APIError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw APIError.invalidResponse
		}
		guard httpResponse.statusCode == 200 else {
			throw APIError.httpError(statusCode: httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let responseJSON = try? JSONDecoder().decode([Candidate].self, from: data) else {
			throw APIError.decodingError
		}
		return responseJSON
	}
	
	func fetchCandidateDetails() async throws -> Candidate {
		guard let baseURL = URL(string: baseURLString) else {
			throw APIError.invalidURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/:candidateId")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "GET"
		
		//Récupération du token
		guard let token = keychain.getToken(key: "authToken") else {
			throw APIError.unauthorized
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw APIError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw APIError.invalidResponse
		}
		guard httpResponse.statusCode == 200 else {
			throw APIError.httpError(statusCode: httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw APIError.decodingError
		}
		return candidate
	}
	
	func addCandidate(email: String, firstName: String, lastName: String) async throws -> Bool {
		print("on est dans repo.addCandidate)")
		guard let baseURL = URL(string: baseURLString) else {
			print("erreur URL")
			throw APIError.invalidURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate")
		
		//body de la requete
		let parameters: [String: Any?] = [
			"email": email,
			"note": nil,
			"linkedinURL": nil,
			"firstName": firstName,
			"lastName": lastName,
			"phone": nil
		]
		
		//conversion en JSON
		let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = jsonData
		
		//Récupération du token
		guard let token = keychain.getToken(key: "authToken") else {
			print("erreur token")
			throw APIError.unauthorized
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {
			print("data is empty")
			throw APIError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			print("response pas de type HTTPURLResponse")
			throw APIError.invalidResponse
		}
		guard httpResponse.statusCode == 201 else {
			print("statusCode error")
			throw APIError.httpError(statusCode: httpResponse.statusCode)
		}
		print("tout s'est bien passé")
		return true
	}
	
	func updateCandidate(id:String, email: String, note: String?, linkedinURL: String?, firstName: String, lastName: String, phone: String?) async throws -> Candidate {
		guard let baseURL = URL(string: baseURLString) else {
			throw APIError.invalidURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/\(id)")
		
		//body de la requete
		let parameters: [String: Any?] = [
			"email": email,
			"note": note,
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
		guard let token = keychain.getToken(key: "authToken") else {
			throw APIError.unauthorized
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw APIError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw APIError.invalidResponse
		}
		guard httpResponse.statusCode == 200 else {
			throw APIError.httpError(statusCode: httpResponse.statusCode)
		}
		
		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw APIError.decodingError
		}
		return candidate
	}
	
	func deleteCandidate(id: String) async throws -> Bool {
		guard let baseURL = URL(string: baseURLString) else {
			throw APIError.invalidURL
		}
		print("on est dans le repo")
		let endpoint = baseURL.appendingPathComponent("/candidate/\(id)")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "DELETE"
		
		//Récupération du token
		guard let token = keychain.getToken(key: "authToken") else {
			throw APIError.unauthorized
		}
		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		
		//lancement appel réseau
		let (_, response) = try await executeDataRequest(request)
		
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw APIError.invalidResponse
		}
		guard httpResponse.statusCode == 200 else {
			throw APIError.httpError(statusCode: httpResponse.statusCode)
		}
		return true
	}
	
	func addCandidateToFavorites(id: String) async throws -> Candidate { //renvoie la valeur inversée de isFavorite
		guard let baseURL = URL(string: baseURLString) else {
			throw APIError.invalidURL
		}
		let endpoint = baseURL.appendingPathComponent("/candidate/\(id)/favorite")
		
		//création de la requête
		var request = URLRequest(url: endpoint)
		request.httpMethod = "POST"
		
		//Récupération du token
		guard let token = keychain.getToken(key: "authToken") else {
			throw APIError.unauthorized
		}

		request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			
		
		//lancement appel réseau
		let (data, response) = try await executeDataRequest(request)
		
		if data.isEmpty {//data est non optionnel dc pas de guard let
			throw APIError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else { //response peut etre de type URLResponse et non HTTPURLResponse donc vérif
			throw APIError.invalidResponse
		}
		guard httpResponse.statusCode == 200 else {
			throw APIError.httpError(statusCode: httpResponse.statusCode)
		}

		//décodage du JSON
		guard let candidate = try? JSONDecoder().decode(Candidate.self, from: data) else {
			throw APIError.decodingError
		}
		return candidate
	}
}
