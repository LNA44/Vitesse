//
//  LoginView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI
struct LoginView: View {
	@ObservedObject var viewModel: LoginViewModel
	@EnvironmentObject var appViewModel: VitesseAppViewModel
	@State private var isAdmin = false
	@State private var isNavigationActive = false //obligatoire car on ne peut pas mettre un bouton (action) dans une navigationlink
	
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
							isNavigationActive = true
							Task {
								await viewModel.login(email: viewModel.email, password: viewModel.password)//implémenter l'appel de la fonction qui appelle l'API pour vérifier un candidat
								isAdmin = viewModel.isAdmin
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
						}
				
					NavigationLink(destination: CandidatesListView(viewModel: appViewModel.candidatesListViewModel, isAdmin: isAdmin), isActive: $isNavigationActive
					) {
						EmptyView() // Un lien invisible qui se déclenche quand isNavigationActive devient true
					}
					
					NavigationLink(destination: RegisterView(viewModel: appViewModel.registerViewModel)) {
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

		}
	}
}

/*#Preview {
	LoginView()
}
*/
