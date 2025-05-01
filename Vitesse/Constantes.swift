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
}
