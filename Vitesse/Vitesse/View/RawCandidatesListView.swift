//
//  RawCandidatesListView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 01/04/2025.
//

import SwiftUI

struct RawCandidatesListView: View {
	let editing: Bool
	let candidate: Candidate
	@ObservedObject var viewModel: CandidatesListViewModel
	
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
