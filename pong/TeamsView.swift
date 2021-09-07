//
//  TeamsView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct TeamsView: View {
	
	@EnvironmentObject var settings: MatchSettings
	@EnvironmentObject var match: Match
	@Binding var showSettings: Bool
	@State var panelWidth: CGFloat
	@State var showControlButtons = true
	
	var body: some View {
		HStack {
			TeamView(tableSide: .left, showControlButtons: $showControlButtons)
			
			VStack {
				if showControlButtons {
					Button(action: { match.singleTapMiddle() }) {
						ButtonImage(systemName: "house")
					}.padding()
				}
				Button(action: { showSettings = !showSettings }) {
					ButtonImage(systemName: "gear")
				}.padding()
			}
			.frame(width: panelWidth)
			
			TeamView(tableSide: .right, showControlButtons: $showControlButtons)
		}
		.onChange(of: settings.showControlButtons) { newValue in
			withAnimation(.spring()) {
				showControlButtons = newValue
			}
		}
	}
	
}

struct TeamsView_Previews: PreviewProvider {
	static var previews: some View {
		TeamsView(showSettings: .constant(false), panelWidth: 200)
	}
}
