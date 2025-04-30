//
//  RegisterView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI

struct RegisterView: View {
	@StateObject var viewModel: RegisterViewModel
	@State private var firstName: String = ""
	@State private var lastName: String = ""
	@State private var email: String = ""
	@State private var password: String = ""
	@State private var isNavigationActive = false
	
	init() {
		let keychain = VitesseKeychainService()
		let repository = VitesseRepository(keychain: keychain)
		_viewModel = StateObject(wrappedValue: RegisterViewModel(repository: repository)) // Injection du repository dans le viewModel
	}
	
	var body: some View {
		VStack {
			Text("Register")
				.font(.system(size: 40, weight: .bold, design: .rounded))
				.padding(.bottom, 40)
			
			Text("First Name")
				.font(.body)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			EntryFieldView(placeHolder: "", field: $viewModel.firstName, isSecure: false, prompt: viewModel.firstNamePrompt)
				.padding(.bottom, 5)
			
			Text("Last Name")
				.font(.body)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			EntryFieldView(placeHolder: "", field: $viewModel.lastName, isSecure: false, prompt: viewModel.lastNamePrompt)
				.padding(.bottom, 5)
			
			Text("Email")
				.font(.body)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			EntryFieldView(placeHolder: "", field: $viewModel.email, isSecure: false, prompt: viewModel.emailPrompt)
				.padding(.bottom, 5)
			
			Text("Password")
				.font(.body)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			EntryFieldView(placeHolder: "", field: $viewModel.password, isSecure: true, prompt: viewModel.passwordPrompt)
				.padding(.bottom, 5)
			
			Text("Confirm password")
				.font(.body)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			EntryFieldView(placeHolder: "", field: $viewModel.confirmPassword, isSecure: true, prompt: viewModel.verifyPasswordPrompt)
				.padding(.bottom, 40)
			
			Button(action: {
				isNavigationActive = true
				Task {
					print("on est dans la task")
					await viewModel.addUser()
					await viewModel.addCandidate()
				}
			}) {
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
			.opacity(viewModel.isSignUpComplete ? 1 : 0.6)
		//1 if true else 0.6
				 .disabled(!viewModel.isSignUpComplete)
				 //désactive : plus d'interaction possible
			
			NavigationLink(destination: LoginView(), isActive: $isNavigationActive
			) {
				EmptyView() // Un lien invisible qui se déclenche quand isNavigationActive devient true
			}
		}
		.padding(60)
		.navigationBarBackButtonHidden(true)
	}
}
//#Preview {
//	RegisterView(viewModel: RegisterViewModel(repository: VitesseService(keychain)))
//}
