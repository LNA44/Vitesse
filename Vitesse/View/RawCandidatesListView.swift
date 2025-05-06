//
//  RawCandidatesListView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 01/04/2025.
//

import SwiftUI

struct RawCandidatesListView: View {
	let editing: Bool //suit editing de la vue parent
	let candidate: Candidate
	@StateObject var viewModel: CandidatesListViewModel
	
    var body: some View {
		if editing == false {
			HStack {
				Text("\(candidate.firstName) \(candidate.lastName)")
					.font(.custom("Roboto_SemiCondensed-Light", size: 18))
				Spacer()
				candidate.isFavorite ? Image(systemName: "star.fill") : Image(systemName: "star")
			}
		} else {
			HStack {
				Button(action : {
					viewModel.toggleSelection(candidate: candidate)
				}) {
					Image(systemName: viewModel.selectedCandidates.contains(candidate.idUUID) ? "checkmark.circle.fill" : "circle")
						.foregroundColor(Color("AppAccentColor"))
				}

				Text("\(candidate.firstName) \(candidate.lastName)")
					.font(.custom("Roboto_SemiCondensed-Light", size: 18))
				Spacer()
				candidate.isFavorite ? Image(systemName: "star.fill") : Image(systemName: "star")
			}
		}
    }
	
}

/*#Preview {
	let simulatedAPIResponse =
	
	// Convertit en un objet de type Candidate
	let simulatedCandidate = Candidate(candidate: simulatedAPIResponse)
	RawCandidatesListView(editing: true, candidate: simulatedCandidate)
}*/
/*#Preview {
	RawCandidatesListView(editing: false, candidate: Candidate(candidate: Candidate(
		phone: "123-456-7890",
		note: "Experienced iOS Developer",
		id: "12345",
		firstName: "John",
		linkedinURL: "https://www.linkedin.com/in/johndoe",
		isFavorite: true,
		email: "johndoe@example.com",
		lastName: "Doe"
		)))
}
*/
