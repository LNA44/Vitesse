//
//  User.swift
//  Vitesse
//
//  Created by Ordinateur elena on 03/04/2025.
//

import Foundation

struct User {
	var firstName: String
	var lastName: String
	var email: String
	var isAdmin: Bool
	
	init(firstName: String, lastName: String, email: String, isAdmin: Bool) {
		self.firstName = firstName
		self.lastName = lastName
		self.email = email
		self.isAdmin = isAdmin
	}
}


