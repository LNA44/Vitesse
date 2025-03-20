//
//  EntryFieldView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 20/03/2025.
//

import SwiftUI

struct EntryFieldView: View {
	var isSecure: Bool = false
	var placeHolder: String
	var prompt: String
	@Binding var field: String
    var body: some View {
		VStack(alignment:.leading) {
			HStack {
				if isSecure {
					SecureField(placeHolder, text: $field).autocapitalization(.none)
				} else {
					TextField(placeHolder, text: $field).autocapitalization(.none)
				}
			}.padding()
				.background(Color(UIColor.secondarySystemBackground))
				.cornerRadius(8)
			Text(prompt)
				.font(.caption)
		}
    }
}

#Preview {
	EntryFieldView(placeHolder: "Mot de passe", prompt: "Entrez un mot de passe valide", field: .constant(""))
}
