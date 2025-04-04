//
//  CandidateListView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI
struct CandidatesListView: View {
	@ObservedObject var viewModel : CandidatesListViewModel
	@State private var editing : Bool = false
	var isAdmin: Bool
	
	var body: some View {
		//NavigationStack {
			VStack {
				TextField("Search", text: .constant(""))
				List {
					if let candidates = viewModel.candidates {
						ForEach(candidates, id: \.idUUID) { candidate in
							HStack {
								NavigationLink (destination: CandidateDetailsView(viewModel: CandidateDetailsViewModel(repository: VitesseService(keychain: VitesseKeyChainService.shared)), candidate: candidate, isAdmin: isAdmin)) { //création de l'instance du VM uniquement lorsque c'est nécessaire
									RawCandidatesListView(editing: editing, candidate: candidate)
								}
							}
						}
					}
				}
			}
			.task {
				await viewModel.fetchCandidates()
			}
			.toolbar {
				ToolbarItem(placement: .principal) {
					Text("Candidats")
						.font(.headline)
				}
				
				if editing == false {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(action: {
							editing = true
						}) {
							Text("Editing")
						}
					}
					
					/*ToolbarItem(placement: .navigationBarTrailing) {
						Button(action: {
							showFavorites.toggle()
						}) {
							Image(systemName: showFavorites ? "star.fill" : "star")
								.foregroundColor(showFavorites ? .yellow : .gray)
						}
					}*/
					
				} else {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Cancel") {
							editing = false
						}
					}
					
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Delete") {
							editing = false
						}
					}
				}
			}
		}
	//}
}
/*
#Preview {
	CandidatesListView(viewModel: CandidatesListViewModel(repository: VitesseService()))
}*/
