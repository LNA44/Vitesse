//
//  LoginView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI
struct LoginView: View {
	@StateObject var viewModel: LoginViewModel
	@State private var isNavigationActive = false //obligatoire car on ne peut pas mettre un bouton (action) dans une navigationlink
	
	init() {
		let keychain = VitesseKeychainService()
		let repository = VitesseRepository(keychain: keychain)
		_viewModel = StateObject(wrappedValue: LoginViewModel(repository: repository)) // Injection du repository dans le viewModel
	}
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 10) {
				Text("Login")
					.font(.system(size: 60, weight: .bold, design: .rounded))
					.padding(.bottom, 70)
				
				Text("Email/Username")
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 5)
				
				EntryFieldView(placeHolder: "", field: $viewModel.email, isSecure: false, prompt: viewModel.emailPrompt)
					.padding(.bottom, 50)
				
				Text("Password")
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 5)
				
				EntryFieldView(placeHolder: "", field: $viewModel.password, isSecure: true, prompt: viewModel.passwordPrompt)
				
				Text("Forgot password?")
					.font(.footnote)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.bottom, 30)
				
				VStack(spacing: 35) {
						Button(action: { //bouton utile pour l'action
							Task {
								let success = await viewModel.login(email: viewModel.email, password: viewModel.password)
								if success {
									isNavigationActive = true
								}
							}
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
								
						}.opacity(viewModel.isSignUpComplete ? 1 : 0.6)
					//1 if true else 0.6
							 .disabled(!viewModel.isSignUpComplete)
							 //désactive : plus d'interaction possible
				
					NavigationLink(destination: CandidatesListView(), isActive: $isNavigationActive
					) {
						EmptyView() // Un lien invisible qui se déclenche quand isNavigationActive devient true
					}
					
					NavigationLink(destination: RegisterView()) {
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
			.padding(60)
			.navigationBarBackButtonHidden(true)
			.alert(isPresented: $viewModel.showingAlert) {
						Alert(title: Text("Identifiant et mot de passe non reconnus"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
					}
		}
		
	}
}

/*#Preview {
	LoginView()
}
*/
