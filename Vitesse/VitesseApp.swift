//
//  VitesseApp.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI

@main
struct VitesseApp: App {
	@StateObject private var viewModel = VitesseAppViewModel()
	let keychain = VitesseKeychainService()

	init() {
		_ = keychain.deleteToken(key: Constantes.Authentication.tokenKey)
	}
	
    var body: some Scene {
        WindowGroup {
			LoginView()
        }
    }
}
