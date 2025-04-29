//
//  APIError.swift
//  Vitesse
//
//  Created by Ordinateur elena on 11/04/2025.
//

import Foundation

enum APIError: LocalizedError {
	case invalidURL
	case unauthorized //token manquant ou faux
	case noData
	case invalidResponse //pas de type HTTPURLResponse
	case httpError(statusCode: Int)
	case decodingError
	
	

	var errorDescription: String {
		switch self {
		case .invalidURL:
			return "The URL is invalid."
		case .invalidResponse: //response pas de type HTTPURLResponse
			return "Invalid response from the server."
		case .httpError(let statusCode):
			return "HTTP error: \(statusCode)"
		case .noData:
			return "No data received from the server."
		case .unauthorized: //token manquant ou invalide
			return "You are not authorized to perform this action."
		case .decodingError:
			return "Decoding error."
		}
	}
}
