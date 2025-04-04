//
//  CandidateDetailsView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 21/03/2025.
//

import SwiftUI

struct CandidateDetailsView: View {
	@ObservedObject var viewModel: CandidateDetailsViewModel
	@State var editing: Bool = true
	@State var essaiEntryField = "0658392874"
	var candidate: Candidate
	var isAdmin: Bool = false 
	
	var body: some View {
		//NavigationStack {
			VStack {
				if editing == false {
					VStack(alignment: .leading) {
						HStack {
							HStack {
								Text(viewModel.candidate?.firstName ?? "No candidate first name")//si candidate = nil -> toute l'expression = nil
								Text(viewModel.candidate?.lastName ?? "No candidate last name")
							}
							.font(.title)
							Spacer()
							Image(systemName: "star.fill")
						}
						.padding(.bottom, 50)
						
						Text(viewModel.candidate?.phone ?? "No candidate phone number")
							.padding(.bottom, 30)
						
						Text(viewModel.candidate?.email ?? "No candidate email")
							.padding(.bottom, 30)
						
						HStack (spacing: 50){
							Text("LinkedIn")
							Button(action: {
								viewModel.convertStringToURL(viewModel.candidate?.linkedinURL)
								if let validURL = viewModel.url {
									UIApplication.shared.open(validURL)
								}
							 }) {
							 Text("Go on LinkedIn")
							 }
							 .foregroundColor(Color.white)
							 .font(.system(size: 10))
							 .padding()
							 .background(Color.blue)
							 .cornerRadius(10)
							 .disabled(viewModel.url == nil) // Désactive le bouton si l'URL n'est pas valide
						}
						.padding(.bottom, 30)
						
						Text("Note")
							.padding(.bottom, 10)
						
						TextEditor(text: Binding(//TextEditor n'accepte pas d'optionnel
							get: { //on crée un binding personnalisé
							viewModel.candidate?.note ?? "" // VM->View : si candidate ou note = nil alors "" renvoyé
						}, set: {
							viewModel.candidate?.note = $0 // View->VM : ce que rentre l'utilisateur envoyé au VM
						}))
							.padding()
							.frame(width: 320, height: 200)
							.cornerRadius(30)
							.overlay {
								RoundedRectangle(cornerRadius: 30)
									.stroke(Color.gray, lineWidth: 1)
							}
							.disabled(!editing)  // Désactive le TextEditor en mode lecture seule
						
						Spacer()
						
					}
					.padding(30)
				} else {
					VStack(alignment: .leading) {
						Text(viewModel.candidate?.firstName ?? "No candidate first name") //\(candidate.firstName, candidate.LastName)
							.font(.title)
							.padding(.bottom, 20)
						
						Text("Phone")
							.padding(.bottom, 5)
						
						EntryFieldView(placeHolder: "", field: Binding(get: { //EntryField ne prend pas d'optionnel
							viewModel.candidate?.phone ?? ""
						}, set: {
							viewModel.candidate?.note = $0
						}),
						isSecure: false, prompt: "",)
						
						Text("Email")
							.padding(.bottom, 5)
						
						EntryFieldView(placeHolder: "",  field: Binding(get: {
							viewModel.candidate?.email ?? ""
						}, set: {
							viewModel.candidate?.email = $0
						}),
						isSecure: false, prompt: "",)
						
						Text("LinkedIn")
							.padding(.bottom, 5)
						
						EntryFieldView(placeHolder: "",  field: Binding(get: {
							viewModel.candidate?.linkedinURL ?? ""
						}, set: {
							viewModel.candidate?.linkedinURL = $0
						}),
						isSecure: false, prompt: "",)
						
						Text("Note")
							.padding(.bottom, 10)
						
						TextEditor(text: Binding(get: {
							viewModel.candidate?.note ?? "" // VM->View : si candidate ou note = nil alors "" renvoyé
						}, set: {
							viewModel.candidate?.note = $0 // View->VM : ce que rentre l'utilisateur envoyé au VM
						}))
							.padding()
							.frame(width: 320, height: 200)
							.cornerRadius(30)
							.overlay {
								RoundedRectangle(cornerRadius: 30)
									.stroke(Color.gray, lineWidth: 1)
							}
						
						Spacer()
						
					}
					.padding(30)
					
				}
				
			}.onAppear {
				// Met à jour le candidat sélectionné dans le VM
				viewModel.candidate = candidate
			}
			.toolbar {
				if editing == false {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button(action: {editing = true}){
							Text("Edit")
						}
					}
				} else {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(action: {editing = false}){
							Text("Cancel")
						}
					}
					
					ToolbarItem(placement: .navigationBarTrailing) {
						Button(action: {editing = false}) {
							Text("Done")
						}
					}
				}
			}
		}
	//}
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
