//
//  ApiService.swift
//  Vitesse
//
//  Created by Ordinateur elena on 05/04/2025.
//

import Foundation

struct VitesseAPIService {
	//MARK: -Private properties
	private let session: URLSession
	
	//MARK: -Initialization
	init(session: URLSession = .shared) {
		self.session = session
	}
	
	//MARK: -Enumerations
	enum Path {
		case login
		case register
		case fetchCandidatesOrAddCandidate
		case fetchOrUpdateOrDeleteCandidateWithID(id: String)
		case candidateWithIDInFavorites(id: String)
		
		// Méthode pour obtenir le chemin sous forme de String en fonction du cas
		func path() -> String {
			switch self {
			case .login:
				return "/user/auth"
			case .register:
				return "/user/register"
			case .fetchCandidatesOrAddCandidate:
				return "/candidate"
			case .fetchOrUpdateOrDeleteCandidateWithID(let id):
				return "/candidate/\(id)"  // Génère le chemin dynamique avec l'ID
			case .candidateWithIDInFavorites(let id):
				return "/candidate/\(id)/favorite"
			}
		}
	}
	
	enum Method: String {
		case get = "GET"
		case post = "POST"
		case put = "PUT"
		case delete = "DELETE"
	}
	
	//MARK: -Methods
	func createEndpoint(path: Path) throws -> URL {
		guard let baseURL = URL(string: "http://127.0.0.1:8080") else {
			throw APIError.invalidURL
		}
		return baseURL.appendingPathComponent(path.path())
	}
	
	//sérialisation
	func serializeParameters(parameters: [String: Any]) throws -> Data?  {
		guard JSONSerialization.isValidJSONObject(parameters) else {
			throw APIError.invalidParameters
		}
		return try? JSONSerialization.data(withJSONObject: parameters, options: [])
	}
	
	//requête
	func createRequest(parameters: [String: Any]? = nil, jsonData: Data?, endpoint: URL, method: Method) -> URLRequest { //modif parametersNeeded -> parameters
		var request = URLRequest(url: endpoint)
		request.timeoutInterval = 5 // délai max d'attente de 5 secondes
		request.httpMethod = method.rawValue
		if parameters != nil {
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = jsonData
			return request
		} else {
			return request
		}
	}
	
	//appel réseau
	func fetch(request: URLRequest, allowEmptyData: Bool = false, allowStatusCode201: Bool = false) async throws -> Data {
		let (data, response) = try await session.data(for: request)
		if !allowEmptyData && data.isEmpty {
			throw APIError.noData
		}
		guard let httpResponse = response as? HTTPURLResponse else {
			throw APIError.invalidResponse
		}
		if httpResponse.statusCode == 429 {
			throw APIError.tooManyRequests
		}
		
		if allowStatusCode201 && httpResponse.statusCode == 201 {
			return data
		}
		guard httpResponse.statusCode == 200 else {
			throw APIError.httpError(statusCode: httpResponse.statusCode)
		}
		return data
	}
	
	func decode<T: Decodable>(_ type: T.Type, data: Data) throws -> T? { //T est décodable
		guard let responseJSON = try? JSONDecoder().decode(T.self, from: data) else { //T: plusieurs types possibles : [String, String], AccountResponse
			throw APIError.decodingError
		}
		return responseJSON
	}
	
	func fetchAndDecode<T: Decodable>(_ type: T.Type, request: URLRequest, allowEmptyData: Bool = false) async throws -> T? {
		let data = try await fetch(request: request,  allowEmptyData: allowEmptyData)
		if data.isEmpty {
			return nil
		}
		let decodedData = try decode(T.self, data: data)
		return decodedData
	}
}
