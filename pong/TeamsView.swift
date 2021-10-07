//
//  TeamsView.swift
//  pong
//
//  Created by Charles Faquin on 8/10/21.
//

import SwiftUI

struct TeamsView: View {
	
	@EnvironmentObject var match: Match
	@Binding var showSettings: Bool
	@Binding var showButtonManager: Bool
	@State var panelWidth: CGFloat
	@State var showControlButtons = false
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		HStack {
			TeamView(player: match.tableSides.home == .left ? $match.settings.homeTeam.playerOne : $match.settings.guestTeam.playerOne, tableSide: .left, showControlButtons: $showControlButtons)
			
			VStack {
				if showControlButtons {
					Button(action: { match.singleTapMiddle() }) {
						ButtonImage(systemName: "house")
					}.padding()
				}
				if !Storage.isMacApp {
					Button(action: { showButtonManager = !showButtonManager }) {
						ButtonImage(systemName: "airplayaudio")
					}
				}
				Button(action: { showSettings = !showSettings }) {
					ButtonImage(systemName: "gear")
				}.padding()
			}
			.frame(width: panelWidth)
			
			TeamView(player: match.tableSides.home == .right ? $match.settings.homeTeam.playerOne : $match.settings.guestTeam.playerOne, tableSide: .right, showControlButtons: $showControlButtons)
		}
		.onChange(of: match.settings.showControlButtons) { newValue in
			withAnimation(.spring()) {
				showControlButtons = newValue
			}
		}
	}
	
}

struct TeamsView_Previews: PreviewProvider {
	static var previews: some View {
		TeamsView(showSettings: .constant(false), showButtonManager: .constant(false), panelWidth: 200)
			.environmentObject(Match())
	}
}
