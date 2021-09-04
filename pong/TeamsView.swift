//
//  TeamsView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct TeamsView: View {
	
	@ObservedObject var match: Match
	@Binding var showSettings: Bool
	@State var panelWidth: CGFloat
	
	var body: some View {
			HStack {
				TeamView(match: match, tableSide: .left)
				
				VStack {
					Button(action: { match.singleTapMiddle() }) {
						ButtonImage(systemName: "house")
					}.padding()
					Button(action: { showSettings = !showSettings }) {
						ButtonImage(systemName: "gear")
					}.padding()
				}
				.frame(width: panelWidth)
				
				TeamView(match: match, tableSide: .right)
			}
	
		
			
		
		
	}
	
	
}

struct TeamsView_Previews: PreviewProvider {
	static var previews: some View {
		TeamsView(match: Match(), showSettings: .constant(false), panelWidth: 200)
	}
}
