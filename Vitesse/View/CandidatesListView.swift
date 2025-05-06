//
//  CandidateListView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI
struct CandidatesListView: View {
	@StateObject var viewModel: CandidatesListViewModel
	@State private var editing : Bool = false
	
	init() {
		let keychain = VitesseKeychainService()
		let repository = VitesseCandidateRepository(keychain: keychain)
		_viewModel = StateObject(wrappedValue: CandidatesListViewModel(repository: repository)) // Injection du repository dans le viewModel
	}
	
	var body: some View {
		VStack {
			TextField("Search", text: $viewModel.searchText)
				.padding()
				.font(.custom("Roboto_SemiCondensed-Light", size: 18))
				.background(Color.white)
				.frame(height: 70)
				.padding(.horizontal, 10)
				
			List {
				ForEach(viewModel.filteredNameCandidates, id: \.idUUID) { candidate in
					ZStack {
						RawCandidatesListView(editing: editing, candidate: candidate, viewModel: viewModel)
							.frame(maxWidth: .infinity, alignment: .leading)
						if editing == false { //éviter de naviguer vers vue suivante en mode édition
							NavigationLink (destination: CandidateDetailsView(candidate: candidate)) {
							}
						}
					}
				}
			}
			.listRowSpacing(15)
			.listStyle(.plain)
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarTitleDisplayMode(.inline)
		.task {
			await viewModel.fetchCandidates()
		}
		
		.toolbar {
			if editing == false {
				ToolbarItem(placement: .navigationBarLeading) {
					Button(action: {
						editing = true
					}) {
						Text("Edit")
							.font(.custom("Roboto_SemiCondensed-Light", size: 18))
							.foregroundColor(Color("Accent"))
					}
				}
				
				ToolbarItem(placement: .principal) {
						Text("Candidats")
							.font(.custom("Roboto_Condensed-Italic", size: 20)) // Utiliser ta police personnalisée
							.foregroundColor(.black) // Exemple de couleur
					}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Image(systemName: viewModel.filterFavorites ? "star.fill" : "star")
						.foregroundColor(Color("Accent"))
						.onTapGesture {
							viewModel.filterFavorites.toggle()
						}
				}
			} else {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancel") {
						editing = false
					}
					.font(.custom("Roboto_SemiCondensed-Light", size: 18))
					.foregroundColor(Color("Accent"))
				}
				
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Delete") {
						Task {
							for candidate in viewModel.selectedCandidates {
								await viewModel.deleteCandidate(id: candidate.uuidString)
							}
							viewModel.selectedCandidates.removeAll()
							await viewModel.fetchCandidates()
							editing = false
						}
					}
					.font(.custom("Roboto_SemiCondensed-Light", size: 18))
					.disabled(viewModel.selectedCandidates.isEmpty)
					.foregroundColor(Color("Accent"))
				}
			}
		}
		.background(Color("SecondaryColor"))
	}
}

#Preview {
	CandidatesListView()
}
