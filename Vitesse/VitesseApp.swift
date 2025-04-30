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
	//@StateObject var session = UserSession.shared
	let keychain = VitesseKeychainService()

	init() {
		_ = keychain.deleteToken(key: "authToken") 
		//_viewModel = StateObject(wrappedValue: VitesseAppViewModel(repository: VitesseService())) //instance unique de VitesseAppViewModel
	}
	
    var body: some Scene {
        WindowGroup {
			LoginView()
        }
    }
}
