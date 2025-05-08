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
	private let keychain = VitesseKeychainService()
	@State private var showAccountCreatedMessage = false
	@Environment(\.scenePhase) private var scenePhase  // Observe l'état de l'application (active, background, inactive)

	init() {}
	
    var body: some Scene {
        WindowGroup {
			LoginView(showAccountCreatedMessage: $showAccountCreatedMessage)
				.alert(isPresented: $viewModel.showAlert) {
					Alert(
						title: Text("Error"),
						message: Text(viewModel.errorMessage ?? "An unknown error happened"),
						dismissButton: .default(Text("OK"))
					)
				}
        }
		.onChange(of: scenePhase) {
			switch scenePhase {
			case .background, .active:
				do {
					// Supprime le token lorsque l'app passe en arrière-plan ou se lance
					_ = try keychain.deleteToken(key: Constantes.Authentication.tokenKey)
				} catch {
					viewModel.showAlert = true
					viewModel.errorMessage = "Erreur lors de la suppression du token : \(error)" //transmis à AuthenticationView pour afficher alerte
				}
			default:
				break
			}
		}
    }
}
