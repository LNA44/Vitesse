//
//  CandidateDetailsView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 21/03/2025.
//

import SwiftUI

struct CandidateDetailsView: View {
	@State var editing: Bool = true
	@State var essaiTextEditor = "blabla"
	@State var essaiEntryField = "0658392874"

	var body: some View {
		NavigationStack {
			VStack {
				if editing == false {
					VStack(alignment: .leading) {
						HStack {
							Text("Jean Michel P.") //\(candidate.firstName, candidate.LastName)
								.font(.title)
							Spacer()
							Image(systemName: "star.fill")
						}.padding(.bottom, 50)
						Text("Phone") //\(candidate.phoneNumber)
							.padding(.bottom, 30)
						Text("Email")//\(candidate.email)
							.padding(.bottom, 30)
						HStack {
							Text("LinkedIn")
							/*Button(action: {
							 candidate.linkedInProfileURL
							 }) {
							 Text("Go on LinkedIn")
							 }*/
						}.padding(.bottom, 30)
						Text("Note")
							.padding(.bottom, 10)
						TextEditor(text: $essaiTextEditor)//$candidate.description
							.padding()
							.frame(width: 320, height: 200)
							.cornerRadius(30)
							.overlay {
								RoundedRectangle(cornerRadius: 30)
									.stroke(Color.gray, lineWidth: 1)
							}
							.disabled(!editing)  // Désactive le TextEditor en mode lecture seule
						Spacer()
					}.padding(30)
				} else {
					VStack(alignment: .leading) {
						Text("Jean Michel P.") //\(candidate.firstName, candidate.LastName)
							.font(.title)
							.padding(.bottom, 20)
						Text("Phone") //\(candidate.phoneNumber)
							.padding(.bottom, 5)
						EntryFieldView(placeHolder: "", prompt: "", field: $essaiEntryField)
						Text("Email")//\(candidate.email)
							.padding(.bottom, 5)
						EntryFieldView(placeHolder: "", prompt: "", field: $essaiEntryField)
						Text("LinkedIn")
							.padding(.bottom, 5)
						EntryFieldView(placeHolder: "", prompt: "", field: $essaiEntryField)
						Text("Note")
							.padding(.bottom, 10)
						TextEditor(text: $essaiTextEditor)//$candidate.description
							.padding()
							.frame(width: 320, height: 200)
							.cornerRadius(30)
							.overlay {
								RoundedRectangle(cornerRadius: 30)
									.stroke(Color.gray, lineWidth: 1)
							}
						Spacer()
					}.padding(30)
				}
			}.toolbar {
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
	}
}

#Preview {
    CandidateDetailsView()
}
