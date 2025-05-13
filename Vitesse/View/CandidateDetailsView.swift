//
//  CandidateDetailsView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 21/03/2025.
//

import SwiftUI

struct CandidateDetailsView: View {
	@StateObject var viewModel: CandidateDetailsViewModel
	@State var editing: Bool = false
	@State var essaiEntryField = "0658392874"
	@Environment(\.dismiss) var dismiss // On accède à l'environnement pour fermer la vue
	
	init(candidateID: String) {
		let keychain = VitesseKeychainService()
		let repository = VitesseCandidateRepository(keychain: keychain)
		_viewModel = StateObject(wrappedValue: CandidateDetailsViewModel(repository: repository, candidateID: candidateID)) // Injection du repository dans le viewModel
	}
	
	var body: some View {
			VStack {
				if editing == false {
					VStack(alignment: .leading) {
						HStack {
							HStack {
								Text(viewModel.firstName)//si candidate = nil -> toute l'expression = nil
								Text(viewModel.lastName)
							}
							.font(.custom("Roboto_Condensed-Italic", size: 25))
							Spacer()
							Button(action : {
								Task {
									await viewModel.toggleFavorite()  // Inverse la valeur de `isFavorite`
								}
							}) {
								Image(systemName: viewModel.isFavorite == true ? "star.fill" : "star")
									.foregroundColor(Color("AppAccentColor"))
							}
						}
						.padding(.bottom, 50)
						
						VStack (alignment: .leading, spacing: 30) {
							HStack (spacing: 30) {
								Text("Phone")
								Text(viewModel.phone ?? "No candidate phone number")
							}
							
							HStack (spacing: 30) {
								Text("Email")
								Text(viewModel.email)
							}
							
							HStack (spacing: 50){
								Text("LinkedIn")
									
								Button(action: {
									if let validURL = viewModel.convertStringToURL(viewModel.linkedinURL) {
										UIApplication.shared.open(validURL)
									}
								}) {
									Text("Go on LinkedIn")
										.font(.custom("Roboto_SemiCondensed-Light", size: 14))
								}
								.foregroundColor(Color.white)
								.padding()
								.frame(width: 150, height: 30)
								.background(Color("AppAccentColor"))
								.cornerRadius(10)
							}
							.padding(.bottom, 25)
						}
						
						Text("Note")
							.padding(.bottom, 10)

						
						ZStack {
							Rectangle()
								.fill(Color("AppSecondaryColor"))
								.frame(width: 320, height: 200)
							
							TextEditor(text: Binding( //TextEditor n'accepte pas d'optionnel donc get set
								get: { //on crée un binding personnalisé
									viewModel.note ?? "" // VM->View : si candidate ou note = nil alors "" renvoyé
								}, set: {
									viewModel.note = $0 // View->VM : ce que rentre l'utilisateur envoyé au VM
								}))
							.scrollContentBackground(.hidden) // désactive le fond interne du texteField
							.background(Color("AppSecondaryColor"))
							.padding()
							.font(.custom("Roboto_SemiCondensed-Light", size: 14))
							.frame(width: 320, height: 200)
							.background(Color.clear) // fond transparent pour enlever le beige ou noir
							.cornerRadius(30)
							.overlay {
								RoundedRectangle(cornerRadius: 30)
									.stroke(Color.gray, lineWidth: 1)
							}
							.disabled(!editing)  // Désactive le TextEditor en mode lecture seule
						}
						
						Spacer()
					}
					.padding(.top, 10)
					.padding(.leading, 30)
					.padding(.trailing, 30)
					.font(.custom("Roboto_SemiCondensed-Light", size: 16))
				} else {
					VStack(alignment: .leading) {
						HStack {
							Text(viewModel.firstName) //\(candidate.firstName, candidate.LastName)
							Text(viewModel.lastName)
						}
						.font(.custom("Roboto_Condensed-Italic", size: 25))
						.padding(.bottom, 20)

						Text("Phone")
							.padding(.bottom, 5)
						
						EntryFieldView(placeHolder: "", field: Binding(get: { //EntryField ne prend pas d'optionnel
							viewModel.phone ?? "" //si nil alors chaine vide
						}, set: { newValue in
							if newValue.isEmpty {
								viewModel.phone = nil // Si l'utilisateur efface le champ, mettre phone à nil
							} else {
								viewModel.phone = newValue // Sinon mettre la nouvelle valeur dans phone
							}}),
						isSecure: false, prompt: "")
						
						Text("Email")
							.padding(.bottom, 5)
						
						EntryFieldView(placeHolder: "", field: $viewModel.email,
						isSecure: false, prompt: "")
						
						Text("LinkedIn")
							.padding(.bottom, 5)
						
						EntryFieldView(placeHolder: "", field: Binding(get: {
							viewModel.linkedinURL ?? ""
						}, set: {
							viewModel.linkedinURL = $0
						}),
						isSecure: false, prompt: "")
						
						Text("Note")
							.padding(.bottom, 10)
						
						ZStack {
							// Fond blanc avec coins arrondis
							RoundedRectangle(cornerRadius: 30)
								.fill(Color.white)
								.frame(width: 320, height: 200)
							TextEditor(text: Binding(get: {
								viewModel.note ?? "" // VM->View : si candidate ou note = nil alors "" renvoyé
							}, set: {
								viewModel.note = $0 // View->VM : ce que rentre l'utilisateur envoyé au VM
							}))
							.padding()
							.font(.custom("Roboto_SemiCondensed-Light", size: 14))
							.frame(width: 320, height: 200)
							.cornerRadius(30)
							.overlay {
								RoundedRectangle(cornerRadius: 30)
									.stroke(Color.gray, lineWidth: 1)
							}
						}
						Spacer()
					}
					.padding(.top, 10)
					.padding(.leading, 30)
					.padding(.trailing, 30)
					.font(.custom("Roboto_SemiCondensed-Light", size: 16))
				}
			}.onAppear {
				Task {
					await viewModel.fetchCandidateDetails()
				}
			}
			.toolbar {
				if editing == false {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(action: {
							dismiss() //ferme la vue et retourne à la vue précédente
						}) {
							Image(systemName: "chevron.left")
								.foregroundColor(Color("AppAccentColor"))
						}
					}
					
					ToolbarItem(placement: .navigationBarTrailing) {
						Button(action: {editing = true}){
							Text("Edit")
						}
						.foregroundColor(Color("AppAccentColor"))
					}
				} else {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(action: {editing = false}){
							Text("Cancel")
								.foregroundColor(Color("AppAccentColor"))
						}
					}
					
					ToolbarItem(placement: .navigationBarTrailing) {
						Button(action: {
							editing = false
							Task {
								await viewModel.updateCandidate()
							}
						}) {
							Text("Done")
						}
						.foregroundColor(Color("AppAccentColor"))
						.disabled(viewModel.email.isEmpty) // Désactive le bouton si l'email est vide
						.opacity(viewModel.email.isEmpty ? 0.5 : 1.0) // Rend le bouton plus opaque si l'email est vide
					}
				}
			}
			.font(.custom("Roboto_SemiCondensed-Light", size: 18))
			.navigationBarBackButtonHidden(true)
			.background(Color("AppSecondaryColor"))
			.alert(isPresented: $viewModel.showAlert) {
				Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
			}
		}
}

/*#Preview {
	let simulatedAPIResponse = VitesseCandidatesListResponse.Candidate(
		phone: "123-456-7890",
		note: "Experienced iOS Developer",
		id: "12345",
		firstName: "John",
		linkedinURL: "https://www.linkedin.com/in/johndoe",
		isFavorite: true,
		email: "johndoe@example.com",
		lastName: "Doe"
		)
	
	let viewModel = CandidateDetailsViewModel(repository: VitesseService(keychain: ))
	
	CandidateDetailsView(candidate: Candidate(candidate: simulatedAPIResponse))
}*/
