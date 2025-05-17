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
	@Binding var showAccountCreatedMessage: Bool
	@State private var showRegisteredNotification = false
	
	init(showAccountCreatedMessage: Binding<Bool>) {
		let keychain = VitesseKeychainService()
		let repository = VitesseAuthenticationRepository(keychain: keychain)
		_viewModel = StateObject(wrappedValue: LoginViewModel(repository: repository)) // Injection du repository dans le viewModel
		_showAccountCreatedMessage = showAccountCreatedMessage // Initialisation du @Binding
	}
	
	var body: some View {
		NavigationStack {
			ZStack {
				GradientBackgroundView()
				
				VStack(spacing: 10) {
					Text("Login")
						.font(.custom("Roboto_SemiCondensed-Bold", size: 60))
						.padding(.bottom, 70)
					
					Text("Email/Username")
						.font(.custom("Roboto_SemiCondensed-Light", size: 16))
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 5)
					
					EntryFieldView(placeHolder: "", field: $viewModel.email, isSecure: false, prompt: viewModel.emailPrompt)
						.padding(.bottom, 50)
					
					Text("Password")
						.font(.custom("Roboto_SemiCondensed-Light", size: 16))
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(.bottom, 5)
					
					EntryFieldView(placeHolder: "", field: $viewModel.password, isSecure: true, prompt: viewModel.passwordPrompt)
					
					Text("Forgot password?")
						.font(.custom("Roboto_SemiCondensed-Light", size: 10))
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
								.font(.custom("Roboto_SemiCondensed-Light", size: 22))
								.padding()
								.foregroundColor(Color.black)
								.background(Color("AppPrimaryColor"))
								.overlay(
									Rectangle()
										.stroke(Color.black, lineWidth: 1)
								)
								.shadow(radius: 5)
							
						}
						.opacity(viewModel.isSignUpComplete ? 1 : 0.6)
						//1 if true else 0.6
						.disabled(!viewModel.isSignUpComplete)
						//désactive : plus d'interaction possible
						
						.navigationDestination(isPresented: $isNavigationActive) {
							CandidatesListView()
						}
						
						NavigationLink(destination: RegisterView()) {
							Text("Register")
								.frame(width: 100, height: 12)
								.font(.custom("Roboto_SemiCondensed-Light", size: 22))
								.foregroundColor(Color.black)
								.padding()
								.background(Color("AppPrimaryColor"))
								.overlay(
									Rectangle()
										.stroke(Color.black, lineWidth: 1)
								)
								.shadow(radius: 5)
						}
					}
				}
				.padding(60)
				.navigationBarBackButtonHidden(true)
				.alert(isPresented: $viewModel.showAlert) {
					Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
				}
				if showRegisteredNotification {
					VStack {
						Spacer()
						Text("Account created successfully!")
							.foregroundColor(.white)
							.fontWeight(.bold)
							.font(.custom("Roboto_SemiCondensed-Light", size: 18))
							.padding()
							.background(Color("AppAccentColor"))
							.cornerRadius(8)
							.shadow(radius: 10)
							.transition(.move(edge: .bottom))
							.onAppear {
								DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
									showRegisteredNotification = false
									showAccountCreatedMessage = false 
								}
							}
					}
					.padding()
				}
			}
			.onChange(of: showAccountCreatedMessage) {
				showRegisteredNotification = true
			}
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	@State static var showAccountCreatedMessage = false
	
	static var previews: some View {
		LoginView(showAccountCreatedMessage: $showAccountCreatedMessage)
	}
}

