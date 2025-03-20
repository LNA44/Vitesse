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
					.font(.headline)
				Text("First Name")
					.font(.body)
				EntryFieldView(placeHolder: "", prompt: "Entrez un prénom valide", field: $firstName)
				Text("Last Name")
					.font(.body)
				EntryFieldView(placeHolder: "", prompt: "Entrez un nom valide", field: $lastName)
				Text("Email")
					.font(.body)
				EntryFieldView(placeHolder: "", prompt: "Entrez un email valide", field: $email)
				Text("Password")
					.font(.body)
				EntryFieldView(placeHolder: "", prompt: "Entrez un mot de passe", field: $password)
				Text("Confirm password")
					.font(.body)
				EntryFieldView(placeHolder: "", prompt: "Confirmez votre mot de passe", field: $password)
				NavigationLink(destination: LoginView()) {
					Button(action: {
						//implémenter l'appel de la fonction qui appelle l'API pour créer un candidat
					}) {
					}
					Text("Create")
				}
			}
		}
	}
}
#Preview {
	RegisterView()
}
