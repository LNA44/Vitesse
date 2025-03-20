//
//  LoginView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI
struct LoginView: View {
	@State private var username: String = ""
	@State private var password: String = ""
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 10) {
				Text("Login")
					.font(.system(size: 70, weight: .bold, design: .rounded))
					.padding(.bottom, 70)
					Text("Email/Username")
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 10)
					EntryFieldView(placeHolder: "", prompt: "Entrez un email ou un nom d'utilisateur valide", field: $username)
					Text("Password")
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 10)
					EntryFieldView(placeHolder: "", prompt: "Entrez un mot de passe", field: $password)
				Text("Forgot password?")
					.font(.footnote)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.bottom, 20)
				VStack(spacing: 40) {
					NavigationLink(destination: CandidatesListView()) {
						Button(action: {
							//implémenter l'appel de la fonction qui appelle l'API pour vérifier un candidat
						}) {
							Text("Sign in")
								.frame(minWidth: 150)
								.font(.system(size: 24))
								.padding()
								.foregroundColor(.blue)
								.background(Color.white)
								.overlay(
									Rectangle()
										.stroke(Color.blue, lineWidth: 2)
								)
								.shadow(radius: 5)
						}
						.onHover { isHovering in
							if isHovering {
								// Changer la couleur de la bordure lors du survol
								// Tu peux modifier la couleur de la bordure, ajouter des animations, etc.
							}
						}
					}
					NavigationLink(destination: RegisterView()) {
						Button(action: {}) {
							Text("Register")
								.frame(minWidth: 150)
								.font(.system(size: 24))
								.padding()
								.foregroundColor(.blue)
								.background(Color.white)
								.overlay(
									Rectangle()
										.stroke(Color.blue, lineWidth: 2)
								)
								.shadow(radius: 5)
						}.onHover { isHovering in
							if isHovering {
								// Changer la couleur de la bordure lors du survol
								// Tu peux modifier la couleur de la bordure, ajouter des animations, etc.
							}
						}
					}
				}
			}.padding(70)
		}
	}
}
#Preview {
	LoginView()
}
