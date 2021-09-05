//
//  ScoreboardView.swift
//  pong
//
//  Created by Charles Faquin on 8/7/21.
//

import SwiftUI

struct ScoreboardView: View {
	
	@EnvironmentObject var settings: MatchSettings
	@ObservedObject var match: Match
	@State var showSettings: Bool = false
	@State var statusText: String = ""
	@State var showStatus: Bool = false
	
	@State var screenSize = UIScreen.main.bounds.size
	
	var body: some View {
		
		ZStack {
			
			VStack {
				TeamsView(match: match, showSettings: $showSettings, panelWidth: panelWidth)
				SeriesView(viewModel: SeriesVM(match, seriesType: .set, panelWidth: panelWidth))
				SeriesView(viewModel: SeriesVM(match, seriesType: .match, panelWidth: panelWidth))
				ScoresView(viewModel: ScoresVM(match, screenSize: screenSize))
			}
			
			VStack {
				Spacer()
				ServiceView(viewModel: ServiceVM(match, panelWidth: panelWidth))
			}.padding()
			
			if showStatus {
				VStack {
					Spacer()
					StatusView(statusText: $statusText)
				
					Spacer()
				}		.animation(.easeInOut)
					.transition(.bottomToTop)
			}
				
		}
		.background(Color.black)
		.sheet(isPresented: $showSettings, onDismiss: nil, content: {
			SettingsView(
				viewModel: SettingsVM(),
				gameType: $match.game.gameType,
				setType: $match.set.setType,
				matchType: $match.matchType,
				showSettings: $showSettings
			)
		})
		.onRotate { newOrientation in
			screenSize = UIScreen.main.bounds.size
		}
		.onChange(of: match.status) { _ in
			handleStateChange()
		}
		.onChange(of: match.game.status) { _ in
			handleStateChange()
		}
	}
	
	
	var panelWidth: CGFloat {
		.panelWidth(screenSize.width)
	}
	
	func handleStateChange() {
		withAnimation {
			if let statusText = match.statusText {
				self.statusText = statusText
			}
			showStatus = match.statusText != nil
		}
	}
	
}

struct ScoreboardView_Previews: PreviewProvider {
	static var previews: some View {
		ScoreboardView(match: Match())
	}
}

enum ToolbarButton: String, CaseIterable {
	case settings = "gear"
	case plus
	case minus
}
