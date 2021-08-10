//
//  TeamView.swift
//  pong
//
//  Created by Charles Faquin on 8/8/21.
//

import SwiftUI

struct TeamView: View {
	
	@State var team: Team

	var body: some View {
			
		VStack(alignment: .center) {
			Text(team.id.rawValue.uppercased())
				.font(.title2)
				.multilineTextAlignment(.center)
			Rectangle()
				.foregroundColor(.secondary)
				.cornerRadius(10)
				.scaledToFill()
			Spacer()
		}.scaledToFit()
		
	}
}

struct TeamView_Previews: PreviewProvider {
	static var previews: some View {
		TeamView(team: Team(.home))
	}
}
