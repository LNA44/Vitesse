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
	@State var showAccountCreatedMessage = false
	
	init() {
		let keychain = VitesseKeychainService()
		let authRepository = VitesseAuthenticationRepository(keychain: keychain)
		let candidateRepository = VitesseCandidateRepository(keychain: keychain)
		_viewModel = StateObject(wrappedValue: RegisterViewModel(authRepository: authRepository, candidateRepository: candidateRepository)) // Injection du repository dans le viewModel
	}
	
	var body: some View {
		ZStack {
			Color("SecondaryColor")
				.edgesIgnoringSafeArea(.all)
			
			VStack {
				Text("Register")
					.font(.custom("Roboto_SemiCondensed-Bold", size: 60))
					.padding(.bottom, 40)
				
				Text("First Name")
					.frame(maxWidth: .infinity, alignment: .leading)
				
				EntryFieldView(placeHolder: "", field: $viewModel.firstName, isSecure: false, prompt: viewModel.firstNamePrompt)
					.padding(.bottom, 5)
				
				Text("Last Name")
					.frame(maxWidth: .infinity, alignment: .leading)
				
				EntryFieldView(placeHolder: "", field: $viewModel.lastName, isSecure: false, prompt: viewModel.lastNamePrompt)
					.padding(.bottom, 5)
				
				Text("Email")
					.frame(maxWidth: .infinity, alignment: .leading)
				
				EntryFieldView(placeHolder: "", field: $viewModel.email, isSecure: false, prompt: viewModel.emailPrompt)
					.padding(.bottom, 5)
				
				Text("Password")
					.frame(maxWidth: .infinity, alignment: .leading)
				
				EntryFieldView(placeHolder: "", field: $viewModel.password, isSecure: true, prompt: viewModel.passwordPrompt)
					.padding(.bottom, 5)
				
				Text("Confirm password")
					.frame(maxWidth: .infinity, alignment: .leading)
				
				EntryFieldView(placeHolder: "", field: $viewModel.confirmPassword, isSecure: true, prompt: viewModel.verifyPasswordPrompt)
					.padding(.bottom, 40)
				
				Button(action: {
					isNavigationActive = true
					Task {
						await viewModel.addUser()
						await viewModel.addCandidate()
						showAccountCreatedMessage = true
					}
				}) {
					Text("Create")
						.frame(width: 100, height: 12)
						.font(.custom("Roboto_SemiCondensed-Light", size: 22))
						.padding()
						.foregroundColor(Color("AppAccentColor"))
						.background(.white)
						.overlay(
							Rectangle()
								.stroke(Color("AppAccentColor"), lineWidth: 2)
						)
						.shadow(radius: 5)
				}
				.opacity(viewModel.isSignUpComplete ? 1 : 0.6)
				//1 if true else 0.6
				.disabled(!viewModel.isSignUpComplete)
				//désactive : plus d'interaction possible
				
				.navigationDestination(isPresented: $isNavigationActive) {
					LoginView(showAccountCreatedMessage: $showAccountCreatedMessage)
				}
			}
			.font(.custom("Roboto_SemiCondensed-Light", size: 16))
			.padding(60)
			.navigationBarBackButtonHidden(true)
		}
		.alert(isPresented: $viewModel.showAlert) {
			Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
		}
	}
}
//#Preview {
//	RegisterView(viewModel: RegisterViewModel(repository: VitesseService(keychain)))
//}
