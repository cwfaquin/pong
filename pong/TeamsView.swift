//
//  TeamsView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct TeamsView: View {
	
	@EnvironmentObject var match: Match
	
    var body: some View {
			HStack {
				Rectangle()
					.foregroundColor(.secondary)
					.cornerRadius(10)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				
				Text("VS")
					.font(.headline)
					.foregroundColor(.yellow)
					.padding()
				
				Rectangle()
					.foregroundColor(.secondary)
					.cornerRadius(10)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
			.fixedSize(horizontal: false, vertical: false)
			.padding()
    }
}

struct TeamsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsView()
    }
}
