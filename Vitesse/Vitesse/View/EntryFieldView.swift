//
//  EntryFieldView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI

struct EntryFieldView: View {
	var placeHolder: String
	@Binding var field: String
	var isSecure: Bool
	var prompt: String
	
	@FocusState private var isFocused: Bool //définit si champ actif ou non, pour animations
	
	var body: some View {
		VStack(alignment:.leading) {
			HStack {
				if isSecure {
					SecureField(placeHolder, text: $field).autocapitalization(.none)
						.focused($isFocused)
						.frame(height: 20)
						.tint(Color("AppPrimaryColor"))
						.onChange(of: field) {
						}
				} else {
					TextField(placeHolder, text: $field).autocapitalization(.none)
						.focused($isFocused)
						.frame(height: 20)
						.tint(Color("AppPrimaryColor"))
						.onChange(of: field) {
						}
				}
			}
			.padding()
			.background(
				ZStack {
					Color(UIColor.secondarySystemBackground)
					Rectangle()
						.stroke(isFocused ? Color("AppPrimaryColor") : Color.gray.opacity(0.5), lineWidth: 1)
						.animation(.easeInOut(duration: 0.2), value: isFocused)
				}
			)
			Text(prompt)
				.font(.custom("Roboto_SemiCondensed-Light", size: 10))
				.font(.caption)
		}
	}
}
