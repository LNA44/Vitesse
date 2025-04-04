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
	
    var body: some View {
		if editing == false {
			HStack (spacing: 100) {
				Text("\(candidate.firstName) \(candidate.lastName)")
				Spacer()
				candidate.isFavorite ? Image(systemName: "star.fill") : Image(systemName: "star")
			}
			.padding(40)
		} else {
			HStack {
				Circle()
					.frame(width: 20, height: 20)
					.padding(.trailing, 30)

				Text("\(candidate.firstName) \(candidate.lastName)")
					.padding(.trailing, 160)

				candidate.isFavorite ? Image(systemName: "star.fill") : Image(systemName: "star")
			}
			.padding(40)
		}
    }
}

#Preview {
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
	
	// Convertit en un objet de type Candidate
	let simulatedCandidate = Candidate(candidate: simulatedAPIResponse)
	RawCandidatesListView(editing: true, candidate: simulatedCandidate)
}
