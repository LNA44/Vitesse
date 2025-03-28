//
//  RegisterView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI

struct RegisterView: View {
	@State private var firstName: String = ""
	@State private var lastName: String = ""
	@State private var email: String = ""
	@State private var password: String = ""

	
	var body: some View {
		NavigationStack {
			VStack {
				Text("Register")
					.font(.system(size: 40, weight: .bold, design: .rounded))
					.padding(.bottom, 40)
				Text("First Name")
					.font(.body)
					.frame(maxWidth: .infinity, alignment: .leading)
				EntryFieldView(placeHolder: "", prompt: "Entrez un prénom valide", field: $firstName)
					.padding(.bottom, 5)
				Text("Last Name")
					.font(.body)
					.frame(maxWidth: .infinity, alignment: .leading)
				EntryFieldView(placeHolder: "", prompt: "Entrez un nom valide", field: $lastName)
					.padding(.bottom, 5)
				Text("Email")
					.font(.body)
					.frame(maxWidth: .infinity, alignment: .leading)
				EntryFieldView(placeHolder: "", prompt: "Entrez un email valide", field: $email)
					.padding(.bottom, 5)
				Text("Password")
					.font(.body)
					.frame(maxWidth: .infinity, alignment: .leading)
				EntryFieldView(placeHolder: "", prompt: "Entrez un mot de passe", field: $password)
					.padding(.bottom, 5)
				Text("Confirm password")
					.font(.body)
					.frame(maxWidth: .infinity, alignment: .leading)
				EntryFieldView(placeHolder: "", prompt: "Confirmez votre mot de passe", field: $password)
					.padding(.bottom, 40)
				NavigationLink(destination: LoginView()) {
					Button(action: {
						//implémenter l'appel de la fonction qui appelle l'API pour créer un candidat
					}) {
					}
					Text("Create")
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
			}.padding(60)
		}
	}
}
#Preview {
	RegisterView()
}
