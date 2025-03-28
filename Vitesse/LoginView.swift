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
					.font(.system(size: 60, weight: .bold, design: .rounded))
					.padding(.bottom, 70)
					Text("Email/Username")
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 5)
					EntryFieldView(placeHolder: "", prompt: "Entrez un email ou un nom d'utilisateur valide", field: $username)
					.padding(.bottom, 50)
					Text("Password")
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 5)
					EntryFieldView(placeHolder: "", prompt: "Entrez un mot de passe", field: $password)
				Text("Forgot password?")
					.font(.footnote)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.bottom, 30)
				VStack(spacing: 35) {
					NavigationLink(destination: CandidatesListView()) {
						Button(action: {
							//implémenter l'appel de la fonction qui appelle l'API pour vérifier un candidat
						}) {
							Text("Sign in")
								.frame(width: 100, height: 12)
								.font(.system(size: 22))
								.padding()
								.foregroundColor(.blue)
								.background(Color.white)
								.overlay(
									Rectangle()
										.stroke(Color.blue, lineWidth: 2)
								)
								.shadow(radius: 5)
						}
					}
					NavigationLink(destination: RegisterView()) {
						Button(action: {}) {
							Text("Register")
								.frame(width: 100, height: 12)
								.font(.system(size: 22))
								.padding()
								.foregroundColor(.blue)
								.background(Color.white)
								.overlay(
									Rectangle()
										.stroke(Color.blue, lineWidth: 2)
								)
								.shadow(radius: 5)
						}
					}
				}
			}.padding(60)
		}
	}
}
#Preview {
	LoginView()
}
