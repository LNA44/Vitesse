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
	
    var body: some View {
		VStack(alignment:.leading) {
			HStack {
				if isSecure {
					SecureField(placeHolder, text: $field).autocapitalization(.none)
						.frame(height: 20)
						.onChange(of: field) {
						}
				} else {
					TextField(placeHolder, text: $field).autocapitalization(.none)
						.frame(height: 20)
						.onChange(of: field) {
						}
				}
			}
			.padding()
			.background(Color(UIColor.secondarySystemBackground))
			.cornerRadius(8)
			Text(prompt)
				.font(.caption)
		}
    }
}
