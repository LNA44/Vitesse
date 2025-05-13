//
//  VitesseAppViewModel.swift
//  Vitesse
//
//  Created by Ordinateur elena on 29/03/2025.
//

import Foundation

class VitesseAppViewModel: ObservableObject {
	//MARK: -Properties
	@Published var isAdmin: Bool = false
	@Published var showAlert: Bool = false
	@Published var errorMessage: String?
}
