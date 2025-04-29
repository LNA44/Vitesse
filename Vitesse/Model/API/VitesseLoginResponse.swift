//
//  VitesseLoginResponse.swift
//  Vitesse
//
//  Created by Ordinateur elena on 01/04/2025.
//

import Foundation
//nécessaire car token et admin pas du même type donc impossible d'utiliser JSONDecoder [String:String]
struct VitesseLoginResponse: Decodable {
	let token: String
	let isAdmin: Bool
}
