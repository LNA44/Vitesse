//
//  VitesseApp.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI

@main
struct VitesseApp: App {
	@StateObject private var viewModel: VitesseAppViewModel
	private let keychain = VitesseKeyChainService.shared
	
	init() {
		keychain.removeToken(key: "authToken") 
		_viewModel = StateObject(wrappedValue: VitesseAppViewModel(repository: VitesseService(keychain: VitesseKeyChainService.shared))) //instance unique de VitesseAppViewModel
	}
	
    var body: some Scene {
        WindowGroup {
			Group { //n'ajoute pas de contraintes visuelles
				if viewModel.isLogged {
					CandidatesListView(viewModel: viewModel.candidatesListViewModel, isAdmin: viewModel.isAdmin)
				} else {
					LoginView(viewModel: viewModel.loginViewModel)
						.transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
												removal: .move(edge: .top).combined(with: .opacity)))
				}
			}
			.environmentObject(viewModel) // utilisé dans  plusieurs vues
        }
    }
}
