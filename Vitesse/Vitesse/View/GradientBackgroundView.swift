//
//  GradientBackgroundView.swift
//  Vitesse
//
//  Created by Ordinateur elena on 17/05/2025.
//

import SwiftUI

struct GradientBackgroundView: View {
	var body: some View {
		LinearGradient(
			gradient: Gradient(colors: [
				Color("GradientTopColor"),
				Color(.white)
			]),
			startPoint: .top,
			endPoint: .bottom
		)
		.ignoresSafeArea()
	}
}

#Preview {
	GradientBackgroundView()
}
