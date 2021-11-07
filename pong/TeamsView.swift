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
	@Binding var showHomeSelection: Bool
	@Binding var showGuestSelection: Bool
	var notMacApp: Bool {
		UIScreen.main.bounds.width <= 1024
	}
	
	var body: some View {
		HStack {
			TeamView(tableSide: .left, showPlayerSelection: match.teamID(.left) == .home ? $showHomeSelection : $showGuestSelection, showControlButtons: $showControlButtons)
			
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
			
			TeamView(tableSide: .right, showPlayerSelection: match.teamID(.right) == .home ? $showHomeSelection : $showGuestSelection, showControlButtons: $showControlButtons)
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
		TeamsView(showSettings: .constant(false), showButtonManager: .constant(false), panelWidth: 200, showHomeSelection: .constant(false), showGuestSelection: .constant(false))
			.environmentObject(Match())
	}
}
