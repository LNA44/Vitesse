//
//  Constantes.swift
//  Vitesse
//
//  Created by Ordinateur elena on 22/04/2025.
//

import Foundation
struct Constantes {
	struct APIService {
		static var baseUrl =  URL(string: "http://127.0.0.1:8080")
	}
	struct Authentication {
		static let tokenKey: String = "authToken"
	}
	struct Candidate {
		static let tokenKey: String = "authToken"
	}
	struct Regex {
		static let email: String = "^([0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\\w]*[0-9a-zA-Z])*\\.)+[a-zA-Z]{2,9})$"
		static let password: String = "^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$"
		static let firstName: String = "^([^ \\x21-\\x26\\x28-\\x2C\\x2E-\\x40\\x5B-\\x60\\x7B-\\xAC\\xAE-\\xBF\\xF7\\xFE]+)$"
		static let lastName: String = "^([^ \\x21-\\x26\\x28-\\x2C\\x2E-\\x40\\x5B-\\x60\\x7B-\\xAC\\xAE-\\xBF\\xF7\\xFE]+)$"
	}
}
