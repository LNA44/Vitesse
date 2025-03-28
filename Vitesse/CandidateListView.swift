//
//  CandidateListView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI

struct CandidatesListView: View {
	var body: some View {
		NavigationStack {
			VStack {
				TextField("Search", text: .constant(""))
				/*List {
					ForEach(viewModel.candidates) { candidate in
						HStack {
							NavigationLink {
								Text(candidate.firstName, candidate.lastName)
								Spacer()
								isFavorite ? Image(systemName: "star.fill") : Image(systemName: "star")
							}
						}
					}
				}*/
		}
			.toolbar {
					ToolbarItem(placement: .principal) {
						Text("Candidats")
							.font(.headline)
					}
			/*	if editing = false{
					
					ToolbarItem(placement: .navigationBarLeading) {
						Button(action: {
							editing = true
						}) {
							Text("Editing")
						}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button(action: {
							showFavorites.toggle()
						}) {
							Image(systemName: showFavorites ? "star.fill" : "star")
								.foregroundColor(showFavorites ? .yellow : .gray)
						}
					}
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
				}*/
			}
		}
	}
}
#Preview {
	CandidatesListView()
}
